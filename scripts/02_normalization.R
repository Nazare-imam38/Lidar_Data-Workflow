# ==============================================================================
# 02_normalization.R
# Purpose: Point cloud classification, DTM generation, and normalization
# ==============================================================================

process_normalization <- function(laz_file, output_dir = "data/processed") {
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

    message(paste("Processing:", basename(laz_file)))

    # Read LAS file
    # Filter to keep only necessary attributes to save memory if file is large
    las <- lidR::readLAS(laz_file, select = "xyzrn")

    # 1. Density Check (Research Grade: 2-5 pts/m^2)
    area_m2 <- sf::st_area(sf::st_as_sfc(lidR::st_bbox(las)))
    density <- lidR::npoints(las) / as.numeric(area_m2)

    message(paste0("Point Density: ", round(density, 2), " pts/m^2"))

    if (density < 2) {
        warning("Point density is below research-grade minimum (2 pts/m^2). Results may be compromised.")
    } else {
        message("Point density meets research-grade requirements (>2 pts/m^2).")
    }

    # Check CRS (Coordinate Integrity)
    if (is.na(lidR::st_crs(las))) {
        warning("LAS file has no CRS. Results may not be georeferenced correctly.")
    }

    # 2. Denoising (Step 2.1)
    # Removing sky points and low outliers using Isolated Voxel Filter (IVF)
    message("Denoising point cloud (IVF)...")
    # res=5, n=6 is a conservative starting point for IVF
    las <- lidR::classify_noise(las, lidR::ivf(res = 5, n = 6))
    las <- lidR::filter_poi(las, Classification != LASNOISE)

    # 3. Ground Classification (CSF) (Step 2.2)
    # Classifies ground points (class 2)
    message("Running Cloth Simulation Filter (CSF)...")
    my_csf <- lidR::csf(sloop_smooth = TRUE, class_threshold = 0.5, cloth_resolution = 0.5)
    las <- lidR::classify_ground(las, algorithm = my_csf)

    # 4. Normalization (Step 2.3)
    # Generate 1m DTM from ground points using TIN
    message("Generating DTM and normalizing...")
    dtm <- lidR::rasterize_terrain(las, res = 1, algorithm = lidR::tin())

    # Subtract DTM from Z
    nlas <- lidR::normalize_height(las, dtm)

    # Final sanity check to remove potential errors below 0
    nlas <- lidR::filter_poi(nlas, Z >= -0.5)

    # Save Normalized LAS
    out_name <- file.path(output_dir, paste0("norm_", basename(laz_file)))
    lidR::writeLAS(nlas, out_name)

    return(list(nlas = nlas, dtm = dtm, filepath = out_name))
}
