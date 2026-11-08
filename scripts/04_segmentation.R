# ==============================================================================
# 04_segmentation.R
# Purpose: Individual Tree Segmentation (ITS) and Biomass Estimation
# ==============================================================================

run_segmentation_pipeline <- function(norm_las, chm, output_dir = "outputs") {
    message("Starting Individual Tree Segmentation (ITS)...")

    # ----------------------------------------------------------------------------
    # Step 4.1: Tree Top Detection (LMF)
    # ----------------------------------------------------------------------------
    # Variable window size: Higher trees need larger windows.
    # Function: window width = 0.1 * height + 1 (example heuristic)
    # Users often define this based on allometric logic for the specific species.
    f <- function(x) {
        x * 0.1 + 0.6
    }

    # Note: hmin = 5 ensures we don't pick up bushes as trees
    ttops <- lidR::locate_trees(norm_las, lidR::lmf(f, hmin = 5))

    # ----------------------------------------------------------------------------
    # Step 4.2: Crown Segmentation (Dalponte 2016)
    # ----------------------------------------------------------------------------
    message("Applying Dalponte (2016) watershed algorithm...")

    # Requires CHM and TTOPS
    algo_seg <- lidR::dalponte2016(chm, ttops)
    las_seg <- lidR::segment_trees(norm_las, algo_seg)

    # ----------------------------------------------------------------------------
    # Step 4.3: Biomass Calculation & Biometrics Extraction
    # ----------------------------------------------------------------------------
    message("Extracting biometrics...")

    # Compute metrics per treeID
    # geom="convex" adds the crown area
    metrics <- lidR::crown_metrics(las_seg, func = .stdtreemetrics, geom = "convex")

    # Drop geometry for inventory calculation to avoid sf-specific overhead and errors
    df_metrics <- sf::st_drop_geometry(metrics)
    
    # Clean output: remove points that are not trees
    # Identify columns first for robust filtering
    col_id <- if ("treeID" %in% names(df_metrics)) "treeID" else if ("ID" %in% names(df_metrics)) "ID" else if ("tree_id" %in% names(df_metrics)) "tree_id" else NULL
    col_z <- if ("Z" %in% names(df_metrics)) "Z" else if ("max_z" %in% names(df_metrics)) "max_z" else NULL
    col_area <- if ("area" %in% names(df_metrics)) "area" else if ("convhull_area" %in% names(df_metrics)) "convhull_area" else NULL

    if (is.null(col_id) || is.null(col_z) || is.null(col_area)) {
        message("Available columns: ", paste(names(df_metrics), collapse = ", "))
        stop("Required columns (TreeID, Z, and Area) not found in metrics. Check lidR version and .stdtreemetrics output.")
    }

    # Filter out NA IDs (points that weren't assigned to a cluster)
    df_metrics <- df_metrics[!is.na(df_metrics[[col_id]]), ]

    if (nrow(df_metrics) == 0) {
        stop("No trees were segmented. Check if your point cloud is normalized correctly.")
    }

    # Allometric Equation
    # Biomass = a * (Height * CrownArea)^b
    a_param <- 0.06
    b_param <- 0.9

    final_inventory <- df_metrics %>%
        dplyr::mutate(
            MaxHeight_m = as.numeric(.data[[col_z]]),
            CrownArea_m2 = as.numeric(.data[[col_area]]),
            EstBiomass_Mg = (a_param * (MaxHeight_m * CrownArea_m2)^b_param) / 1000
        ) %>%
        dplyr::rename(TreeID = !!col_id) %>%
        dplyr::select(TreeID, MaxHeight_m, CrownArea_m2, EstBiomass_Mg)

    # Outputs

    # 1. Save Segmented Point Cloud
    out_laz <- file.path(output_dir, "segmented_forest.laz")
    lidR::writeLAS(las_seg, out_laz)

    # 2. Save Inventory
    out_csv <- file.path(output_dir, "tree_inventory.csv")
    write.csv(final_inventory, out_csv, row.names = FALSE)
    message("Segmentation complete. Inventory and LAS saved.")
    return(final_inventory)
}
