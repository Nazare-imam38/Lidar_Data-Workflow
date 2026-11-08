# ==============================================================================
# Lidar Analytics Dashboard (Shiny App)
# Purpose: GUI for Automated 3D Forest Carbon & Biomass Analytics
# ==============================================================================

library(shiny)
library(bslib)
library(leaflet)
library(DT)
library(plotly)
library(terra)
library(sf)
library(dplyr)

# Load existing pipeline scripts
source("scripts/00_setup.R")
source("scripts/01_ingestion.R")
source("scripts/02_normalization.R")
source("scripts/03_surface_modeling.R")
source("scripts/04_segmentation.R")

# Modern UI using bslib
ui <- page_sidebar(
    theme = bs_theme(
        bootswatch = "darkly",
        primary = "#00bc8c",
        base_font = font_google("Inter")
    ),
    title = "Forest Carbon & Biomass Analytics",
    sidebar = sidebar(
        title = "Pipeline Control",
        textInput("site_code", "NEON Site Code", value = "HARV"),
        selectInput("year", "Data Year", choices = 2018:2024, selected = 2019),
        hr(),
        actionButton("run_pipeline", "Run Full Pipeline", class = "btn-primary w-100"),
        br(),
        downloadButton("download_csv", "Export Inventory", class = "btn-success w-100 mt-2"),
        hr(),
        helpText("Note: Processing LiDAR data is resource-intensive. Ensure your system has at least 16GB RAM for large tiles.")
    ),

    # Layout with cards and tabs
    layout_column_wrap(
        width = 1 / 3,
        value_box(
            title = "Total Trees Detected",
            value = textOutput("stat_tree_count"),
            showcase = bsicons::bs_icon("tree"),
            theme_color = "primary"
        ),
        value_box(
            title = "Avg. Tree Height",
            value = textOutput("stat_avg_height"),
            showcase = bsicons::bs_icon("bar-chart-fill"),
            theme_color = "info"
        ),
        value_box(
            title = "Total Est. Biomass (Mg)",
            value = textOutput("stat_total_biomass"),
            showcase = bsicons::bs_icon("activity"),
            theme_color = "success"
        )
    ),
    navset_card_pill(
        nav_panel(
            "Analytics Map",
            card(
                card_header("Spatial Distribution"),
                leafletOutput("map_view", height = "500px")
            )
        ),
        nav_panel(
            "Tree Inventory",
            card(
                card_header("Segmented Tree Data"),
                DTOutput("inventory_table")
            )
        ),
        nav_panel(
            "Statistical Insights",
            card(
                card_header("Biomass vs. Height Correlation"),
                plotlyOutput("biomass_plot")
            )
        ),
        nav_panel(
            "Processing Logs",
            card(
                card_header("System Console"),
                verbatimTextOutput("log_output")
            )
        )
    )
)

server <- function(input, output, session) {
    # Reactive list to store results
    res <- reactiveValues(
        inventory = NULL,
        chm = NULL,
        logs = "Ready to process...\n"
    )

    # Run the pipeline
    observeEvent(input$run_pipeline, {
        withProgress(message = "Executing Pipeline...", value = 0, {
            # Step 1: Ingestion
            incProgress(0.1, detail = "Downloading/Checking Data...")
            res$logs <- paste0(res$logs, "Phase 1: Ingestion started...\n")

            # Use defined directories
            DATA_DIR <- "data/raw"

            # Find files (simplified logic from main.R)
            lidar_files <- list.files(file.path(DATA_DIR, "laz"), pattern = "\\.laz$", full.names = TRUE)

            if (length(lidar_files) == 0) {
                download_neon_data(site_code = input$site_code, year = as.character(input$year), output_dir = DATA_DIR)
                lidar_files <- list.files(file.path(DATA_DIR, "laz"), pattern = "\\.laz$", full.names = TRUE)
            }

            if (length(lidar_files) == 0) {
                res$logs <- paste0(res$logs, "ERROR: No data found for this site/year.\n")
                return()
            }

            target_file <- lidar_files[1]
            res$logs <- paste0(res$logs, "Selected: ", basename(target_file), "\n")

            # Step 2: Normalization
            incProgress(0.3, detail = "Cleaning & Normalizing Point Cloud...")
            res$logs <- paste0(res$logs, "Phase 2: Normalization processing...\n")
            norm_results <- process_normalization(target_file, output_dir = "data/processed")

            # Step 3: Surface Modeling
            incProgress(0.2, detail = "Generating CHM...")
            res$logs <- paste0(res$logs, "Phase 3: Generating Surface Models...\n")
            surfaces <- generate_surfaces(norm_results$nlas, output_dir = "outputs")
            res$chm <- surfaces$chm

            # Step 4: Segmentation
            incProgress(0.4, detail = "Delineating Tree Crowns...")
            res$logs <- paste0(res$logs, "Phase 4: Segmentation & Metrics...\n")
            inventory_df <- run_segmentation_pipeline(norm_results$nlas, surfaces$chm, output_dir = "outputs")

            res$inventory <- inventory_df
            res$logs <- paste0(res$logs, "Pipeline Complete! Results Loaded.\n")
        })
    })

    # Stats outputs
    output$stat_tree_count <- renderText({
        if (is.null(res$inventory)) {
            return("-")
        }
        nrow(res$inventory)
    })

    output$stat_avg_height <- renderText({
        if (is.null(res$inventory)) {
            return("- m")
        }
        paste(round(mean(res$inventory$MaxHeight_m, na.rm = TRUE), 2), "m")
    })

    output$stat_total_biomass <- renderText({
        if (is.null(res$inventory)) {
            return("- Mg")
        }
        paste(round(sum(res$inventory$EstBiomass_Mg, na.rm = TRUE), 1))
    })

    # Map
    output$map_view <- renderLeaflet({
        l <- leaflet() %>%
            addProviderTiles(providers$Esri.WorldImagery) %>%
            setView(lng = -72.17, lat = 42.53, zoom = 14) # Default HARV coords

        if (!is.null(res$chm)) {
            # Convert terra to stars for leaflet if needed, or use simple bounds
            # For simplicity, we center on the tile
            ext <- terra::ext(res$chm)
            crs_proj <- terra::crs(res$chm)
            # In a real app, we'd project the raster to 4326 for leaflet
            # Here we just show the base map
        }
        l
    })

    # Table
    output$inventory_table <- renderDT({
        if (is.null(res$inventory)) {
            return(NULL)
        }
        datatable(res$inventory, options = list(pageLength = 10), class = "display compact")
    })

    # Plot
    output$biomass_plot <- renderPlotly({
        if (is.null(res$inventory)) {
            return(NULL)
        }

        p <- ggplot2::ggplot(res$inventory, ggplot2::aes(x = MaxHeight_m, y = EstBiomass_Mg, size = CrownArea_m2, color = MaxHeight_m)) +
            ggplot2::geom_point(alpha = 0.5) +
            ggplot2::scale_color_viridis_c() +
            ggplot2::theme_minimal() +
            ggplot2::labs(title = "Biomass Relationship", x = "Tree Height (m)", y = "Estimated Biomass (Mg)")

        ggplotly(p)
    })

    # Logs
    output$log_output <- renderText({
        res$logs
    })

    # Download
    output$download_csv <- downloadHandler(
        filename = function() {
            paste("forest_inventory_", Sys.Date(), ".csv", sep = "")
        },
        content = function(file) {
            write.csv(res$inventory, file, row.names = FALSE)
        }
    )
}

shinyApp(ui, server)
