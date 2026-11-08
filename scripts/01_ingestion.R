# ==============================================================================
# 01_ingestion.R
# Purpose: Programmatically fetch LiDAR products from NEON API
# ==============================================================================

download_neon_data <- function(site_code = "HARV", output_dir = "data/raw", year = "2021") {
    if (!dir.exists(output_dir)) dir.create(output_dir, recursive = TRUE)

    message(paste("Initiating NEON LiDAR download for site:", site_code))

    # Discrete return LiDAR point cloud Data Product ID: DP1.30003.001
    # Using byTileAOP for AOP data (Remote Sensing) as required by neonUtilities
    # Selected Tile Coordinates for HARV (Harvard Forest):
    # Easting: 732000, Northing: 4713000 (Central HARV area, ensuring coverage)

    tryCatch(
        {
            # byTileAOP downloads the specific tile for the given year
            neonUtilities::byTileAOP(
                dpID = "DP1.30003.001",
                site = site_code,
                year = year,
                easting = 732000,
                northing = 4713000,
                savepath = output_dir,
                check.size = FALSE
            )

            # Organize files
            # NEON tools download into nested folder structure: year/site/etc.
            # We want to flatten this or just find the laz files.
            downloaded_files <- list.files(output_dir, pattern = "\\.laz$", full.names = TRUE, recursive = TRUE)

            if (length(downloaded_files) > 0) {
                message(paste("Found", length(downloaded_files), "downloaded LAZ files."))

                # Move to a centralized 'laz' directory for the pipeline
                dest_dir <- file.path(output_dir, "laz")
                if (!dir.exists(dest_dir)) dir.create(dest_dir, recursive = TRUE)

                for (f in downloaded_files) {
                    # Check if file is already in dest_dir to avoid overwriting or moving self
                    if (dirname(f) != normalizePath(dest_dir, winslash = "/")) {
                        file.copy(f, file.path(dest_dir, basename(f)), overwrite = TRUE)
                    }
                }
                message("Data ingestion and organization complete.")
            } else {
                warning("No LAZ files found after download. Check coordinates or year compatibility.")
            }
        },
        error = function(e) {
            message("Error during data ingestion: ", e$message)
            message("Ensure neonUtilities is installed and you have internet access.")
        }
    )
}
