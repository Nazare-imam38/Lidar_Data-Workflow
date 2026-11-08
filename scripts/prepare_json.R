# prepare_json.R
library(dplyr)
library(jsonlite)

# Load the inventory
inventory <- read.csv("outputs/tree_inventory.csv")

# 1. Summary Statistics
stats <- list(
    total_trees = nrow(inventory),
    avg_height = round(mean(inventory$MaxHeight_m), 2),
    max_height = round(max(inventory$MaxHeight_m), 2),
    total_biomass_mg = round(sum(inventory$EstBiomass_Mg), 2),
    avg_crown_area = round(mean(inventory$CrownArea_m2), 2)
)

# 2. Height Distribution (Histogram)
# Bins: 5 to max_height in steps of 2
breaks <- seq(0, ceiling(stats$max_height / 2) * 2, by = 2)
h <- hist(inventory$MaxHeight_m, breaks = breaks, plot = FALSE)
height_dist <- data.frame(
    bin = paste0(h$breaks[-length(h$breaks)], "-", h$breaks[-1]),
    count = h$counts
)

# 3. Sample for Scatter Plot (limit to 1000 points for performance)
set.seed(42)
scatter_sample <- inventory %>%
    sample_n(min(1000, nrow(inventory))) %>%
    select(MaxHeight_m, CrownArea_m2, EstBiomass_Mg)

# 4. Biomass by Height Range
biomass_dist <- inventory %>%
    mutate(height_bin = cut(MaxHeight_m, breaks = seq(0, 50, by = 5))) %>%
    group_by(height_bin) %>%
    summarise(total_biomass = sum(EstBiomass_Mg), count = n()) %>%
    filter(!is.na(height_bin))

# Combine all
final_data <- list(
    stats = stats,
    height_distribution = height_dist,
    scatter_sample = scatter_sample,
    biomass_summary = biomass_dist
)

# Save to JSON for the dashboard
write_json(final_data, "dashboard/src/data/forest_metrics.json", pretty = TRUE, auto_unbox = TRUE)
message("Dashboard data generated at dashboard/src/data/forest_metrics.json")
