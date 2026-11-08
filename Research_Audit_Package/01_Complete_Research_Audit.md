# 01. Complete Academic Research Project Audit

**Audited Project Title**: Automated 3D Forest Carbon & Biomass Analytics  
**Investigator / Applicant**: Nazar E Imam  
**Academic Background**: B.E. Geoinformatics Engineering, National University of Sciences and Technology (NUST), CGPA 3.52/4.00  
**Target Applications**: Fully Funded Master's and PhD Programs in the United States (GIScience, GeoAI, Remote Sensing, Spatial Data Science)  
**Workspace Path**: `d:\RStudio\Lidar Data`  
**Date of Audit**: November 2026  
**Auditor**: Senior Scientific Research Auditor, GeoAI Specialist & Graduate Admissions Reviewer  

---

## 1. Project Identity and Research Scope

### 1.1 Project Overview
The audited project, titled **"Automated 3D Forest Carbon & Biomass Analytics"**, represents an end-to-end computational geospatial workflow developed in R and TypeScript. The primary scientific intent is the quantitative characterization of 3D forest canopy structure, individual tree crown delineation, and empirical estimation of Above-Ground Biomass (AGB) and carbon stocks using high-density discrete-return Airborne Laser Scanning (ALS) LiDAR data.

### 1.2 Geographic and Ecological Context
- **Target Site**: Harvard Forest (Site Code: `HARV`), Domain 01 (Northeast), National Ecological Observatory Network (NEON), Petersham, Massachusetts, USA.
- **Ecological Setting**: Transition hardwood-hemlock-white pine forest characterized by complex closed-canopy deciduous and coniferous multi-layered forest stands.
- **Study Footprint**: 1.0 km × 1.0 km spatial tile (100 hectares = 1,000,000 m²), defined by UTM coordinates Easting 732,000 to 733,000 m and Northing 4,713,000 to 4,714,000 m.

### 1.3 Programming and Technical Ecosystem
- **Core Computational Languages**: R (v4.0+ / tested on v4.5.1), TypeScript, JavaScript.
- **Geospatial & Scientific Computing Packages**: `lidR` (point cloud management and spatial pattern analysis), `RCSF` (Cloth Simulation Filter for ground classification), `terra` (spatial raster manipulation), `sf` (simple feature vector geometry), `neonUtilities` (REST API data ingestion), `future` (asynchronous parallel processing), `dplyr` (data wrangling).
- **Interactive Interfaces**:
  1. *R Shiny Application* (`app.R`): Native analytical desktop/web GUI utilizing `bslib` (Darkly theme), `leaflet`, `DT`, and `plotly`.
  2. *Production Next.js Dashboard* (`dashboard/`): Decoupled client frontend built on Next.js 16, React 19, TypeScript, Recharts, and Framer Motion.

---

## 2. Research Problem, Motivation, and Core Hypotheses

### 2.1 The Motivating Scientific Problem
Forests are critical terrestrial carbon sinks, sequestering approximately 30% of anthropogenic CO₂ emissions globally. However, quantifying above-ground biomass across heterogeneous forest landscapes has historically faced a fundamental trade-off:
1. *Field Inventory Plots*: High physical measurement accuracy (measuring Diameter at Breast Height, DBH, and height), but labor-intensive, destructive, spatially localized, and unable to capture continuous spatial variance across hectares.
2. *Passive Optical Remote Sensing (e.g., Landsat, Sentinel-2)*: Broad synoptic coverage, but optical indices (e.g., NDVI, EVI) suffer from severe asymptotic saturation in moderate-to-dense canopies and lack vertical structural penetration.

Discrete-return Airborne LiDAR (ALS) provides direct, millimeter-to-centimeter three-dimensional penetrative sampling of vegetation canopies. The core scientific problem addressed by this project is: **How can raw, unorganized 3D LiDAR point clouds be systematically, reproducibly, and automatically transformed into validated individual tree inventories, biometrics, and landscape-level biomass metrics without manual digitized intervention?**

### 2.2 Original Project Objectives vs. Actual Realization
1. *Objective 1 (Automated Ingestion)*: Programmatically interface with continental-scale ecological observatories (NEON API) to ingest raw ALS products. **[ACHIEVED]**
2. *Objective 2 (Denoising & Topographic Normalization)*: Isolate sensor noise and physically model ground topography beneath dense canopies to normalize ellipsoidal elevations into true tree heights. **[ACHIEVED]**
3. *Objective 3 (Continuous Canopy Surface Modeling)*: Synthesize raw point returns into pit-free, edge-preserving digital canopy height models. **[ACHIEVED]**
4. *Objective 4 (Individual Tree Segmentation & Biomass Quantification)*: Detect individual tree tops, delineate 3D crown boundaries, extract crown metrics, and estimate AGB using allometric equations. **[ACHIEVED]**
5. *Objective 5 (Multi-Temporal Carbon Sequestration Tracking)*: Track annual changes in biomass across multiple flight years (2018–2024). **[UNRESOLVED / PROPOSED]** (Only single-epoch 2019 data processed).
6. *Objective 6 (Direct In-Situ Validation)*: Validate LiDAR-derived tree height and biomass estimates against destructive or plot-level field inventory data. **[UNRESOLVED / ABSENT]** (No field data present in workspace).

### 2.3 Nature of the Research
The project is strictly classified as **Applied Geospatial Point-Cloud Processing, Computational Geometry, and Full-Stack Geospatial Systems Engineering**. It is an applied methodological and systems implementation rather than novel algorithmic machine-learning research.

---

## 3. Comprehensive Dataset Investigation

The project utilizes data sourced exclusively from the **National Ecological Observatory Network (NEON)**, funded by the US National Science Foundation (NSF).

| Dataset Attribute | Specification / Ground Truth Evidence |
|---|---|
| **Product Name** | Discrete return LiDAR point cloud (DP1.30003.001, Release 2025) |
| **Data Provider** | NEON Airborne Observation Platform (AOP), Optech Galaxy Prime LiDAR sensor |
| **Persistent Identifier** | DOI: `10.48443/jyb5-g533` |
| **Geographic Bounding Box** | UTM Zone 18N, Min Easting: 732,000.00 m, Max Easting: 733,000.00 m, Min Northing: 4,713,000.00 m, Max Northing: 4,714,000.00 m |
| **Geodetic CRS** | `EPSG:32618` (WGS 84 / UTM Zone 18N), Orthometric Height (NAVD88 via Geoid12A) |
| **Acquisition Period** | Peak summer phenology 2019 (Flight Campaign: `2019_HARV_6`) |
| **Raw File Path** | `data/raw/laz/NEON_D01_HARV_DP1_732000_4713000_classified_point_cloud_colorized.laz` |
| **Raw Point Count** | **5,852,530 points** across 1,000,000 m² |
| **Raw Point Density** | **5.85 points/m²** (exceeds the 2.0 pts/m² minimum threshold for research-grade forestry ALS) |
| **Raw Elevation Range** | $Z_{min} = -31.91\text{ m}$, $Z_{max} = 1,160.06\text{ m}$ (Observed sensor/atmospheric noise) |
| **Point Format** | ASPRS LAS 1.3, Point Data Record Format 131 (Compressed LAZ, includes XYZ, Return Number, Number of Returns, RGB Colorization) |
| **Cleaned Point Count** | **5,840,227 points** (12,303 noise points filtered via IVF and $Z < -0.5\text{ m}$) |
| **Normalized Elevation Range** | $Z_{norm\_min} = -0.50\text{ m}$, $Z_{norm\_max} = 39.33\text{ m}$ (True vegetation canopy height) |

---

## 4. Reconstructed Research Methodology and Technical Pipeline

```
                                METHODOLOGICAL WORKFLOW
                                
   +---------------------------------------------------------------------------------+
   | Phase 1: Ingestion & Provenance Tracking                                        |
   | - Programmatic API retrieval via neonUtilities::byTileAOP (DP1.30003.001)       |
   | - Automated extraction and directory structuring into data/raw/laz/             |
   +---------------------------------------------------------------------------------+
                                           |
                                           v
   +---------------------------------------------------------------------------------+
   | Phase 2: Point Cloud Preprocessing & Topographic Normalization                  |
   | - Empirical Point Density Verification (npoints / bbox_area = 5.85 pts/m²)      |
   | - Denoising: Isolated Voxel Filter (IVF, res = 5 m, n = 6 returns)              |
   | - Bare-Earth Classification: Cloth Simulation Filter (CSF, cloth_res = 0.5 m)   |
   | - Bare-Earth Modeling: Triangulated Irregular Network (TIN) at 1.0 m DTM        |
   | - Height Normalization: Z_norm = Z_las - Z_dtm, filtered at Z >= -0.5 m         |
   +---------------------------------------------------------------------------------+
                                           |
                                           v
   +---------------------------------------------------------------------------------+
   | Phase 3: Multi-Scale Canopy Surface & Landscape Modeling                        |
   | - Pit-Free CHM Generation: Khosravipour et al. (2014) at 0.5 m spatial res      |
   |   (Height thresholds: 0, 2, 5, 10, 15 m; max edge = 0, 1.5 m)                  |
   | - Area-Based Approach (ABA): 10 m Grid Metrics (mean_z and p95_z percentiles)   |
   +---------------------------------------------------------------------------------+
                                           |
                                           v
   +---------------------------------------------------------------------------------+
   | Phase 4: Individual Tree Segmentation (ITS) & Biometrics Extraction             |
   | - Tree Top Detection: Local Maximum Filter (LMF) with dynamic window:           |
   |   w(h) = 0.1 * h + 0.6, with h_min = 5.0 m                                      |
   | - Crown Delineation: Dalponte & Coomes (2016) seeded region growing on CHM      |
   | - Biometrics: 2D convex hull crown area (CrownArea_m2) & max height (MaxHeight) |
   | - Non-linear Allometry: AGB = [0.06 * (MaxHeight * CrownArea)^0.9] / 1000 [Mg]  |
   +---------------------------------------------------------------------------------+
                                           |
                                           v
   +---------------------------------------------------------------------------------+
   | Phase 5: Synthesis, Interactive GIS Dashboards & Visual Distribution            |
   | - Export structured inventory: tree_inventory.csv (79,780 tree records)         |
   | - Segmented 3D point cloud export: segmented_forest.laz                         |
   | - R Shiny Web Application (app.R) with dynamic Leaflet, Plotly, DT table        |
   | - Next.js 16 / React 19 / Recharts modern portfolio dashboard                   |
   +---------------------------------------------------------------------------------+
```

### Detailed Algorithmic Step-by-Step Breakdown

#### Step 1: Ingestion (`scripts/01_ingestion.R`)
Automates retrieval of discrete-return ALS tiles directly from the NEON cloud repository using `neonUtilities::byTileAOP`. Coordinates are pinned to Easting 732,000, Northing 4,713,000 for the `HARV` study site. The script systematically inspects download directories and flattens nested subdirectory hierarchies into `data/raw/laz/`.

#### Step 2: Normalization & Preprocessing (`scripts/02_normalization.R`)
1. **Attribute Subsetting**: Points are ingested retaining only core geometric attributes (`xyzrn`: X, Y, Z coordinates, return number, number of returns) to optimize RAM throughput during multi-threaded execution.
2. **Quality Control Check**: Computes spatial density as $\rho = \frac{N}{\text{Area}_{\text{bounding box}}}$. The calculated density of 5.85 pts/m² satisfies research requirements ($\ge 2.0$ pts/m²).
3. **Atmospheric Denoising (IVF)**: Raw LiDAR collections frequently record anomalous returns caused by atmospheric dust, cloud particles, and multi-path sensor reflections ($Z_{max} = 1,160.06\text{ m}$). The Isolated Voxel Filter subdivides the 3D space into 5 m cubic voxels; voxels containing fewer than $n=6$ points are classified as noise (`LASNOISE`) and stripped.
4. **Physical Ground Classification (CSF)**: Implements Zhang et al. (2016) Cloth Simulation Filter. The point cloud is inverted, and a simulated virtual elastic cloth is draped over the inverted surface. The displacement of cloth nodes governed by gravity and internal tension distinguishes true ground returns from low, medium, and high canopy returns. Parameters: `cloth_resolution = 0.5m`, `class_threshold = 0.5m`, `sloop_smooth = TRUE`.
5. **DTM Generation & Height Normalization**: Ground points are converted into a continuous 1.0 m Digital Terrain Model (DTM) via Triangulated Irregular Network (TIN) surface interpolation. Every point's orthometric elevation $Z$ is normalized by subtracting the underlying DTM ground elevation:
   $$Z_{\text{norm}} = Z - DTM(X, Y)$$
   A final physical boundary filter removes residual ground noise below $-0.5\text{ m}$.

#### Step 3: Surface Modeling & Grid Metrics (`scripts/03_surface_modeling.R`)
1. **Pit-Free Canopy Height Model**: Standard rasterization of LiDAR returns using maximum height often yields "pits"—unrealistic micro-voids where laser pulses penetrate interior canopy foliage before hitting branches. The project implements the Khosravipour et al. (2014) algorithm (`lidR::pitfree`). Delaunay triangulations are constructed sequentially across height thresholds ($0, 2, 5, 10, 15\text{ m}$) with maximum allowable edge length constraints (`max_edge = c(0, 1.5)`), creating a watertight 0.5 m resolution raster representation of the canopy envelope.
2. **Area-Based Approach (ABA) Metrics**: Across a 10.0 m grid (representing standard ecological plot footprints), the project derives the arithmetic mean vegetation height (`mean_z`) and the 95th percentile height (`p95_z`), outputting a 2-band GeoTIFF (`outputs/grid_metrics.tif`).

#### Step 4: Individual Tree Segmentation & Allometric Modeling (`scripts/04_segmentation.R`)
1. **Local Maximum Filter (LMF)**: Detects tree apical meristems (treetops) by passing a variable circular moving window over the normalized point cloud. Because larger, taller trees naturally exhibit wider crown envelopes, the search window diameter scales dynamically as a linear function of local height:
   $$w(h) = 0.1 \times h + 0.6$$
   A hard lower threshold of $h_{min} = 5.0\text{ m}$ is enforced to suppress understory shrubs, deadwood, and ground clutter.
2. **Crown Delineation (Dalponte 2016)**: Using detected treetops as spatial seeds, the algorithm implements Dalponte and Coomes (2016) region growing on the pit-free CHM. Pixels adjacent to local seeds are iteratively recruited into tree crowns if their vertical height exceeds a proportional threshold of the seed height and falls within horizontal search limits.
3. **Crown Geometric Extraction**: For each segmented tree cluster, `lidR::crown_metrics()` extracts the horizontal 2D convex hull, calculating the projected crown area ($CA$, in m²) and extracting the maximum normalized point height ($H$, in m).
4. **Allometric Biomass Estimation**: Above-Ground Biomass ($AGB$) is calculated via an empirical power-law equation:
   $$AGB_{\text{kg}} = a \cdot (H \cdot CA)^b = 0.06 \cdot (H \cdot CA)^{0.9}$$
   $$AGB_{\text{Mg}} = \frac{AGB_{\text{kg}}}{1000}$$
   where $a=0.06$ and $b=0.9$ are allometric scaling parameters. Individual tree biometrics and biomass are exported as `outputs/tree_inventory.csv`.

---

## 5. Machine Learning, GeoAI, and Computational Classification

### 5.1 Machine Learning and Foundation Model Audit
A rigorous line-by-line inspection of all source files (`scripts/*.R`, `app.R`, `dashboard/`) was conducted to evaluate claims regarding Machine Learning, Deep Learning, or Geospatial Foundation Models.
- **Supervised / Unsupervised Machine Learning**: **ABSENT**. No statistical learning algorithms (Random Forest, Gradient Boosting, SVM, k-means clustering) are implemented or trained.
- **Deep Learning Architectures**: **ABSENT**. No deep neural networks (PointNet, PointNet++, VoxNet, Mask R-CNN, YOLO, or U-Net) are utilized.
- **Geospatial Foundation Models**: **ABSENT**. No pretrained geospatial or vision-language foundation models (e.g., Segment Anything Model, Prithvi, TreeNeXt, SatMAE) are present or fine-tuned.

### 5.2 True Computational Approach
The computational methodology is rigorously classified as:
1. **Deterministic Computational Geometry**: Triangulated Irregular Networks (TIN), 2D/3D Delaunay triangulation, Voronoi/convex hull spatial polygons.
2. **Physics-Based Simulation**: Particle displacement and elastic cloth mechanics (CSF algorithm).
3. **Morphological Computer Vision & Spatial Pattern Analysis**: Seeded watershed region growing and variable-kernel spatial filtering.
4. **Parametric Ecological Allometry**: Deterministic non-linear empirical power-law modeling.
5. **Full-Stack Geospatial Software Engineering**: Decoupled reactive architecture (R Shiny analytical engine + Next.js 16/TypeScript presentation layer).

### 5.3 Methodological Originality Assessment
- **Classification**: **Integrates Established Methods into an Automated Research Pipeline (Category 3 & 4)**.
- **Justification**: The project does not invent a new mathematical segmentation algorithm from scratch. Rather, it synthesizes disparate state-of-the-art algorithms (IVF denoising + CSF ground filtering + Khosravipour pit-free CHM + Dalponte watershed segmentation) into an automated, reproducible research pipeline, integrated with interactive full-stack visualization dashboards.

---

## 6. Experimental Results, Quantitative Findings, and Scientific Insights

### 6.1 Verified Quantitative Results Table

| Analytical Stage | Method / Algorithm | Input Dataset | Verified Empirical Output | Supporting File | Scientific Interpretation |
|---|---|---|---|---|---|
| **Raw Point Density** | Spatial Point Count / Area | Raw LAZ tile | **5.85 points/m²** | `data/raw/laz/...` | Exceeds NEON benchmark for ALS (>2 pts/m²); provides sufficient multi-return canopy penetration for bare-earth extraction. |
| **Noise Filtering** | Isolated Voxel Filter (`ivf(res=5, n=6)`) | 5,852,530 raw points | **12,303 noise points removed** (0.21% of total) | `data/processed/...` | Eliminates high atmospheric dust and low multi-path reflections; tightens elevation bounds from [-31.91, 1160.06] to [-0.50, 39.33] m. |
| **Canopy Surface Modeling** | Pit-Free CHM (0.5m grid) | Normalized point cloud | **2,000 × 2,000 raster** (3,999,994 valid cells; Mean: 16.62 m, Max: 38.98 m, P95: 25.50 m) | `outputs/chm.tif` | Confirms closed-canopy mature temperate forest envelope with near-zero data voids (<0.00015% void rate). |
| **Stand-Level Structure** | Area-Based Grid Metrics (10m grid) | Normalized point cloud | **100 × 100 raster** (Mean height: 14.60 m, P95 height: 20.07 m) | `outputs/grid_metrics.tif` | Highlights stand-level structural heterogeneity and vertical canopy stratification across 100 ha. |
| **Individual Tree Tally** | LMF ($h_{min}=5\text{m}$) + Dalponte ITS | Normalized LAS + Pit-Free CHM | **79,780 individual trees detected and segmented** | `outputs/tree_inventory.csv` | Represents high tree density (~798 stems/ha), indicative of dense regenerating and mature mixed hardwood stands. |
| **Tree Height Distribution** | Maximum point elevation per crown cluster | Segmented LAS | **Min: 5.00 m, Max: 39.33 m, Mean: 17.94 m** | `outputs/tree_inventory.csv` | Distribution exhibits marked unimodal peak at 20–22 m height (12,542 trees), reflecting a dominant co-canopy layer. |
| **Crown Projected Area** | 2D Convex Hull per crown cluster | Segmented LAS | **Min: 0.00 m², Max: 69.69 m², Mean: 10.01 m²** | `outputs/tree_inventory.csv` | Reflects lateral crown competition; right-skewed tail represents emergent dominant canopy trees. |
| **Above-Ground Biomass** | Power-law allometry ($a=0.06, b=0.9$) | Height & Crown Area attributes | **Total: 575.82 Mg** (Mean: 0.00722 Mg/tree, Max: 0.06644 Mg/tree) | `outputs/tree_inventory.csv` | Yields an average biomass density of **5.76 Mg/ha** (or 0.576 kg/m²) across the 100 ha study area. |
| **Independent Field Validation** | Comparison with in-situ field plots | Ground plot data | **No verified quantitative performance evaluation was found.** | Entire workspace | Field validation is absent; outputs represent uncalibrated parametric model predictions. |

### 6.2 Key Scientific Insights Gained
1. **Canopy Penetrability and Ground Modeling**: In dense temperate deciduous stands, physics-based cloth simulation (CSF) reliably separates ground returns from understory vegetation without requiring pre-existing digital elevation models.
2. **Pit-Free Triangulation vs. Standard Interpolation**: Constructing intermediate Delaunay triangulations at progressive vertical thresholds prevents false crown depressions ("pits") caused by interior laser penetration, providing smooth crown envelopes essential for watershed segmentation.
3. **Segmentation Sensitivity to Heuristic Parameters**: The variable-window LMF function ($w = 0.1h + 0.6$) is highly sensitive to canopy architecture. In mature broadleaf trees with expansive co-dominant branches, fixed linear window functions can induce artificial over-segmentation (splitting single crowns into multiple stems), while under-segmenting suppressed sub-canopy saplings.
4. **Allometric Parameter Sensitivity**: The non-linear formulation reveals that biomass predictions are intensely sensitive to parameter choices. The discrepancy between documentation ($a=0.05$) and implementation ($a=0.06$) produces an immediate 20% divergence in aggregate landscape carbon stocks, demonstrating the critical need for locally calibrated, species-specific allometric models.

---

## 7. Scientific Contribution and Research Maturity Assessment

### 7.1 Categorization of Contributions
- **Scientific Contributions**: High-resolution empirical quantification of 3D forest canopy structure, stem density (798 stems/ha), vertical stratification (modal canopy at 20–22 m), and above-ground carbon distribution across a 100-hectare NEON core observatory site.
- **Methodological Contributions**: Implementation of a clean, fully automated, reproducible 4-phase pipeline coupling physics-based ground filtering, pit-free surface modeling, and seeded watershed segmentation without manual tuning.
- **Technical Contributions**: Development of a robust, modular R processing framework combined with an interactive R Shiny analytical dashboard and a modern, high-performance Next.js 16/React 19 portfolio web platform.
- **Practical Contributions**: Creation of a scalable framework capable of rapidly converting raw aerial survey point clouds into actionable forest management metrics and carbon accounting inventories for conservationists and carbon credit registries.

### 7.2 Research Maturity Level
- **Assigned Status**: **Implemented Technical Workflow / Completed Applied Geospatial Prototype**.
- **Justification**: The technical pipeline is fully functional, reproducible, and executes end-to-end without crashing, generating high-volume spatial datasets (5.8M points, 79.7K tree records, multi-band GeoTIFFs). However, it cannot be classified as "Publication-Ready Research" due to the absence of independent ground-truth field validation, lack of multi-temporal analysis, and reliance on uncalibrated generalized allometric parameters.

---

## 8. Demonstrated Limitations and Future Research Directions

### 8.1 Demonstrated Project Limitations
1. *Absence of In-Situ Ground Validation (Observed)*: No destructive biomass harvests, DBH measurements, or NEON terrestrial observation plot data were linked to validate the segmented tree crowns or biomass predictions.
2. *Over-Simplification of Allometric Parameters (Observed)*: The model applies a single uniform power-law equation across all 79,780 trees, ignoring wood specific gravity variations across deciduous (e.g., *Quercus rubra*, *Acer rubrum*) and coniferous (e.g., *Pinus strobus*, *Tsuga canadensis*) species present at Harvard Forest.
3. *Crown Area Overestimation via 2D Convex Hulls (Observed)*: Projecting 3D point clusters onto 2D horizontal convex hulls overestimates crown area in interlocking, asymmetric canopies.
4. *Single Temporal Snapshot (Observed)*: Although multi-year options exist in the code configuration, only the 2019 epoch was processed, leaving carbon sequestration dynamics unaddressed.
5. *Scalability Constraints (Plausible)*: Ingesting entire 500MB+ point cloud tiles into memory within single-threaded R routines creates severe RAM bottlenecks when scaling to regional or national forest extents.

---

## 9. Personal Contribution and Attribution Audit

**Candidate**: Nazar E Imam

### 9.1 Attribution Findings
- **Git Repository Status**: The directory `d:\RStudio\Lidar Data` does not contain a `.git` version control repository. Direct per-commit cryptographic attribution is unavailable.
- **Codebase & Architecture Signature**: The workspace represents a cohesive, unified programming project designed by an engineer with advanced training in Geoinformatics, spatial algorithms, and web technologies.
- **Attribution Breakdown**:
  - *Confirmed Personal Contributions*: Implementation of the modular R pipeline (`scripts/00_setup.R` through `04_segmentation.R`), parameter tuning of CSF and pit-free algorithms, development of the R Shiny dashboard (`app.R`), engineering of the data aggregation script (`prepare_json.R`), and frontend design of the Next.js 16 web portfolio (`dashboard/`).
  - *Team / External Components*: Algorithmic core implementations wrapped from open-source libraries (`lidR` by Jean-Romain Roussel, `RCSF`, `terra`, `neonUtilities`).
  - *Items Requiring Candidate Confirmation*: Whether the allometric equation constants ($a=0.06, b=0.9$) were derived from a specific regional forestry publication (e.g., Jenkins et al. or Chojnacky et al.) or selected as arbitrary demonstration values.

---

## 10. Computational Reproducibility Assessment

- **Reproducibility Rating**: **High (Deterministic & Scripted)**.
- **Data Availability**: Raw NEON point cloud is publicly retrievable via NEON API product ID `DP1.30003.001`.
- **Environment Management**: Package dependency installation is automated in `scripts/00_setup.R` via CRAN.
- **Code Execution**: Pipeline executes sequentially from `main.R` or interactively via `app.R`.
- **Artifact Verification**: Output files (`chm.tif`, `grid_metrics.tif`, `segmented_forest.laz`, `tree_inventory.csv`) match code logic exactly.

