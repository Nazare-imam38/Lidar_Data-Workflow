# 06. Project File Manifest

## Project Root Directory Overview
- **Project Directory**: `d:\RStudio\Lidar Data`
- **Primary Technologies**: R (v4.0+ / v4.5.1), Next.js 16 (React 19, TypeScript, Recharts, Framer Motion), R Shiny, GDAL/terra, lidR, RCSF.
- **Scientific Domain**: Forestry Remote Sensing, Airborne Laser Scanning (ALS), Quantitative 3D Forest Structure Analysis, Individual Tree Segmentation (ITS), Allometric Above-Ground Biomass (AGB) Estimation, Full-Stack Geospatial Dashboard Engineering.

---

## Complete File Manifest and Research Inventory

### 1. Master Pipeline & Workflow Orchestration
| Relative File Path | File Size | Primary Language / Format | Function / Role | Research Significance |
|---|---|---|---|---|
| `main.R` | 3,002 B | R Script | Top-level execution driver (Phase 1–4 sequential pipeline orchestration) | Coordinates the end-to-end analytical workflow: configures target parameters (`SITE_CODE = "HARV"`, `YEAR = "2019"`), controls data ingestion, triggers point cloud normalization, generates pit-free raster surfaces, and executes individual tree crown delineation. |
| `Lidar Data.Rproj` | 218 B | RStudio Project Configuration | Environment initialization and workspace tracking | Defines project encoding (UTF-8), tab spacing (2 spaces), indexing settings, and establishes the root working directory for reproducible relative paths. |
| `README.md` | 2,052 B | Markdown Document | High-level technical overview & architecture notes | Documents the 4-phase architecture, dependencies (`lidR`, `sf`, `terra`, `neonUtilities`, `future`, `dplyr`), execution guidelines, research-grade density checks (>5 pts/m²), allometric formulas, and Next.js frontend instructions. |
| `.Rhistory` | 0 B | Plaintext Log | R command-line execution history | Empty session history (0 bytes), confirming script execution occurred programmatically or inside dedicated sub-shells/IDE sessions. |

---

### 2. Core Scientific & Algorithmic Modules (`scripts/`)
| Relative File Path | File Size | Primary Language / Format | Core Functions / Implemented Logic | Research Significance |
|---|---|---|---|---|
| `scripts/00_setup.R` | 1,164 B | R Script | `install_missing()`, `lidR::set_lidr_threads()` | Ensures strict computational reproducibility; automatically audits and installs CRAN dependencies (`lidR`, `RCSF`, `sf`, `terra`, `neonUtilities`, `future`, `dplyr`, `tools`), initializes global parallel computing threads (`detectCores() - 1`). |
| `scripts/01_ingestion.R` | 2,130 B | R Script | `download_neon_data(site_code, output_dir, year)` | Automates programmatic retrieval of discrete-return Airborne LiDAR Point Clouds (Data Product ID `DP1.30003.001`) via the NEON API (`neonUtilities::byTileAOP`) for spatial coordinates Easting 732000, Northing 4713000 (Harvard Forest). Handles nested directory extraction and centralization into `data/raw/laz/`. |
| `scripts/02_normalization.R` | 2,476 B | R Script | `process_normalization(laz_file, output_dir)` | Executes data quality assurance: point density validation (>2 pts/m² check), coordinate reference verification, Isolated Voxel Filter (`lidR::ivf(res=5, n=6)`) noise removal, Cloth Simulation Filter (`lidR::csf()`) physical ground classification, 1m DTM interpolation via Triangulated Irregular Network (`lidR::tin()`), vertical elevation normalization, and negative-Z sanity filtering (`Z >= -0.5m`). |
| `scripts/03_surface_modeling.R` | 1,643 B | R Script | `generate_surfaces(norm_las, output_dir)` | Rasterizes 3D point structure into continuous surfaces. Implements Khosravipour et al. (2014) Pit-Free Canopy Height Model (`lidR::pitfree()`) algorithm at 0.5m spatial resolution using height thresholds `c(0, 2, 5, 10, 15)`. Computes Area-Based Approach (ABA) grid metrics at 10m resolution (mean height and 95th percentile height). |
| `scripts/04_segmentation.R` | 3,365 B | R Script | `run_segmentation_pipeline(norm_las, chm, output_dir)` | Conducts Individual Tree Detection (ITD) using Local Maximum Filter (`lidR::lmf()`) with dynamic window function $w = 0.1 \times h + 0.6$ ($h_{min} = 5.0\text{ m}$); performs Individual Tree Segmentation (ITS) using the Dalponte and Coomes (2016) seeded region growing algorithm (`lidR::dalponte2016()`); extracts crown convex hulls and biometrics (`lidR::crown_metrics()`); computes above-ground biomass ($AGB$) via power-law allometry; exports segmented point cloud and structured CSV inventory. |
| `scripts/prepare_json.R` | 1,617 B | R Script | Data aggregation & export pipeline for Web GUI | Ingests `tree_inventory.csv`, computes summary statistics, generates 2m-binned height histograms, extracts a 1,000-tree representative sample for scatter plotting, summarizes biomass across 5m height classes, and outputs a formatted JSON payload (`dashboard/src/data/forest_metrics.json`). |

---

### 3. Interactive Web Dashboards & UI Systems
| Relative File Path | File Size | Primary Language / Format | Architecture & Components | Research Significance |
|---|---|---|---|---|
| `app.R` | 7,868 B | R Shiny Application | Bootstrap 5 (`bslib` Darkly theme), `leaflet`, `DT`, `plotly`, `terra`, `sf` | Interactive analytical GUI allowing on-demand execution of the 4-phase pipeline directly from a web browser. Features real-time metric cards, Leaflet spatial mapping, interactive DataTables of segmented trees, and Plotly bivariate height-biomass scatter plots. |
| `dashboard/package.json` | 557 B | JSON Configuration | Node.js project manifest (Next.js 16, React 19, TypeScript, Lucide, Recharts) | Defines dependencies for the production-grade portfolio frontend dashboard. |
| `dashboard/src/app/page.tsx` | 5,652 B | TypeScript / React TSX | Responsive web dashboard layout with animated glassmorphism cards and charts | Renders client-side analytical dashboard: KPI metric banners, responsive Recharts bar chart (tree height distribution), multi-variable scatter plot (Height vs. Biomass vs. Crown Area), and conceptual methodology flow. |
| `dashboard/src/data/forest_metrics.json` | 107,100 B | JSON Data File | Pre-calculated forest biometrics and statistical distributions | Serves as the static data layer powering the Next.js frontend, decoupling heavy LiDAR spatial analysis from high-performance client rendering. |
| `dashboard/src/app/page.module.css` | 3,095 B | CSS Module | Dark-themed glassmorphism styling | Custom UI styling providing aesthetic, accessible presentation of scientific metrics. |

---

### 4. Input Datasets & Acquisition Metadata (`data/`)
| Relative File Path | File Size | Format | Spatial Extent / Properties | Research Significance |
|---|---|---|---|---|
| `data/raw/laz/NEON_D01_HARV_DP1_732000_4713000_classified_point_cloud_colorized.laz` | 43,449,964 B (~43.45 MB) | ASPRS LAS 1.3 (Point Format 131) | 1 km × 1 km (Easting 732000–733000, Northing 4713000–4714000), UTM Zone 18N (EPSG: 32618). Raw Points: 5,852,530. Raw Z: -31.91 m to 1160.06 m. | Primary raw input dataset. Acquired by NEON Airborne Observation Platform (AOP) over Harvard Forest in 2019. Contains raw coordinates, RGB colorization, return numbers, and classification flags. |
| `data/processed/norm_NEON_D01_HARV_DP1_732000_4713000_classified_point_cloud_colorized.laz` | 17,655,091 B (~17.66 MB) | ASPRS LAS 1.3 (Point Format 131) | 1 km × 1 km, UTM Zone 18N. Points: 5,840,227. Normalized Z: -0.50 m to 39.33 m. | Intermediate preprocessed point cloud. Denoised via IVF (12,303 noise points removed), ground-classified via CSF, and height-normalized against a 1m TIN DTM. |
| `data/raw/DP1.30003.001/citation_DP1.30003.001_RELEASE-2025.txt` | 624 B | BibTeX Citation File | DOI: `10.48443/jyb5-g533` | Formal provenance and citation record from NEON for Data Product DP1.30003.001 (Release 2025). |
| `data/raw/DP1.30003.001/issueLog_DP1.30003.001.csv` | 4,204 B | CSV Log | NEON sensor calibration and issue log | Documents known issues in NEON AOP sensor campaigns, including strip misalignment and flight-line vertical discrepancies across flight seasons. |
| `data/raw/DP1.30003.001/.../TileBoundary/shps/...` | ~15 KB (shp, shx, dbf, prj, kml) | ESRI Shapefile & KML | UTM Zone 18N polygon boundary | Official spatial footprint and geodetic reference metadata defining the 1 km² tile boundary. |

---

### 5. Derived Research Outputs (`outputs/`)
| Relative File Path | File Size | Format | Spatial / Tabular Properties | Research Significance |
|---|---|---|---|---|
| `outputs/chm.tif` | 12,716,275 B (~12.72 MB) | GeoTIFF (Float32, Single-Band) | 2,000 × 2,000 pixels (0.5m resolution), UTM 18N. 3,999,994 valid cells. Min: 0.00 m, Max: 38.98 m, Mean: 16.62 m, P95: 25.50 m. | Continuous raster representation of forest canopy top surface, eliminating pit artifacts through height-thresholded Delaunay triangulation. Essential input for crown segmentation. |
| `outputs/grid_metrics.tif` | 81,266 B (~81 KB) | GeoTIFF (Float32, 2-Band) | 100 × 100 pixels (10.0m resolution), UTM 18N. Band 1: `mean_z` (-0.02 m to 27.01 m, mean 14.60 m). Band 2: `p95_z` (0.07 m to 38.60 m, mean 20.07 m). | Macro-scale forest structural metrics following the Area-Based Approach (ABA), capturing stand-level height variability and structural complexity. |
| `outputs/segmented_forest.laz` | 22,011,496 B (~22.01 MB) | ASPRS LAS 1.3 (Point Format 131) | 5,840,227 points, UTM 18N. Z range: -0.50 m to 39.33 m. Includes assigned `treeID` attribute. | Fully segmented 3D point cloud where each individual canopy return is explicitly linked to an identified tree crown cluster. |
| `outputs/tree_inventory.csv` | 3,087,857 B (~3.09 MB) | Structured CSV | 79,780 rows, 4 fields: `TreeID`, `MaxHeight_m`, `CrownArea_m2`, `EstBiomass_Mg`. | Primary quantitative experimental result. Contains explicit biometrics for all 79,780 segmented trees across the 100-hectare study tile. |

---

### 6. Visual Verification Evidence (`Output Sc/`)
| Relative File Path | File Size | Format | Content | Research Significance |
|---|---|---|---|---|
| `Output Sc/1.png` | 1,702,594 B | PNG (1894 × 826) | Web dashboard hero section | Verifies total tree tally (79,780), mean height (17.94m), max height (39.33m), and aggregate biomass (575.82 Mg). |
| `Output Sc/2.png` | 128,869 B | PNG (1896 × 780) | Interactive bivariate scatter plot | Demonstrates non-linear allometric relationship and tooltip biometrics inspection. |
| `Output Sc/3.png` | 120,338 B | PNG (1893 × 787) | Height frequency histogram | Shows peak canopy stratification mode at 20–22 meters (12,542 trees). |
| `Output Sc/4.png` | 130,932 B | PNG (1893 × 832) | Pipeline architecture schematic | Confirms execution modularity across Ingestion, Preprocessing, Modeling, and Segmentation. |

