# ==============================================================================
# 03_surface_modeling.R
# Purpose: Generate Pit-Free Canopy Height Model (CHM) and Grid Metrics
# ==============================================================================

generate_surfaces <- function(norm_las, output_dir = "outputs") {
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

    # ----------------------------------------------------------------------------
    # Step 3.1: CHM Generation (Pit-free)
    # ----------------------------------------------------------------------------
    message("Generating Pit-Free Canopy Height Model (CHM)...")

    # Pit-Free Algorithm (Khosravipour et al.)
    # Using sequence of height thresholds
    algo <- lidR::pitfree(thresholds = c(0, 2, 5, 10, 15), max_edge = c(0, 1.5))

    # Generate CHM at 0.5m resolution
    chm <- lidR::rasterize_canopy(norm_las, res = 0.5, algorithm = algo)

    # Save CHM
    out_path_chm <- file.path(output_dir, "chm.tif")
    terra::writeRaster(chm, out_path_chm, overwrite = TRUE)

    # ----------------------------------------------------------------------------
    # Step 3.2: Grid Metrics (Area-Based Approach)
    # ----------------------------------------------------------------------------
    message("Calculating Grid Metrics (Area-Based)...")

    # Standard metrics: mean height and 95th percentile
    # We use a 20m pixel size which is common for forest inventory plots
    # or 10m depending on the survey. Defaulting to 10m for high res.

    metrics_grid <- lidR::pixel_metrics(norm_las, ~ list(mean_z = mean(Z), p95_z = quantile(Z, 0.95)), res = 10)

    # Save Grid Metrics
    out_path_metrics <- file.path(output_dir, "grid_metrics.tif")
    terra::writeRaster(metrics_grid, out_path_metrics, overwrite = TRUE)

    return(list(chm = chm, grid_metrics = metrics_grid))
}
