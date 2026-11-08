# ==============================================================================
# 00_setup.R
# Purpose: dependency management and environment setup
# ==============================================================================

# List of required packages
required_packages <- c(
    "lidR", # Point cloud processing
    "RCSF", # Cloth Simulation Filter (Needed for csf())
    "sf", # Spatial vector data
    "terra", # Raster data
    "neonUtilities", # NEON data access
    "future", # Parallel processing
    "dplyr", # Data manipulation
    "tools" # File path handling
)

# Function to check and install missing packages
install_missing <- function(pkgs) {
    new_pkgs <- pkgs[!(pkgs %in% installed.packages()[, "Package"])]
    if (length(new_pkgs)) {
        message("Installing missing packages: ", paste(new_pkgs, collapse = ", "))
        install.packages(new_pkgs, repos = "https://cloud.r-project.org")
    }

    # Load all packages
    sapply(pkgs, require, character.only = TRUE)
}

install_missing(required_packages)

# Set global options
options(lidR.progress = TRUE)
lidR::set_lidr_threads(parallel::detectCores() - 1) # Auto-configure threads

message("Environment setup complete. lidR threads set to: ", get_lidr_threads())
