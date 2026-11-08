# ==============================================================================
# MAIN PIPELINE: Automated 3D Forest Carbon & Biomass Analytics
# Target Site: HARV (Harvard Forest)
# ==============================================================================

# 1. Setup Environment
source("scripts/00_setup.R")

# Load Modules
source("scripts/01_ingestion.R")
source("scripts/02_normalization.R")
source("scripts/03_surface_modeling.R")
source("scripts/04_segmentation.R")

# Configuration
SITE_CODE <- "HARV"
YEAR <- "2019" # 2018-2022 are good years for NEON
DATA_DIR <- "data/raw"
OUTPUT_DIR <- "outputs"

# ==============================================================================
# PHASE 1: Data Ingestion
# ==============================================================================
# Checks if data exists, otherwise downloads.
# In a real scenario, this fetches potentially multiple files.
lidar_files <- list.files(file.path(DATA_DIR, "laz"), pattern = "\\.laz$", full.names = TRUE)

if (length(lidar_files) == 0) {
    message("No local LiDAR data found. Attempting download via NEON API...")
    download_neon_data(site_code = SITE_CODE, year = YEAR, output_dir = DATA_DIR)
    lidar_files <- list.files(file.path(DATA_DIR, "laz"), pattern = "\\.laz$", full.names = TRUE)
}

if (length(lidar_files) == 0) {
    stop("Phase 1 Failed: No LiDAR files available for processing.")
}

# Select just one file for processing (Simulation of 1km tile processing)
target_file <- lidar_files[1]
message(paste("Selected file for processing:", basename(target_file)))

# ==============================================================================
# PHASE 2: Point Cloud Pre-processing (The Cleaning)
# ==============================================================================
# Includes Density Check, Denoising, CSF, and Normalization
norm_results <- process_normalization(target_file, output_dir = "data/processed")
norm_las <- norm_results$nlas

# ==============================================================================
# PHASE 3: Forest Structure Metrics (The Rasterization)
# ==============================================================================
# Includes Pit-Free CHM and Area-Based Grid Metrics
surfaces <- generate_surfaces(norm_las, output_dir = OUTPUT_DIR)
current_chm <- surfaces$chm

# ==============================================================================
# PHASE 4: Individual Tree Segmentation (The Analysis)
# ==============================================================================
# Includes LMF, Dalponte Segmentation, and Biomass Calculation
inventory <- run_segmentation_pipeline(norm_las, current_chm, output_dir = OUTPUT_DIR)

# ==============================================================================
# REPORT
# ==============================================================================
print(head(inventory))
message("Pipeline executed successfully.")
