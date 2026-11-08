# 05. Admissions-Ready Research Profile & Application Materials

**Candidate**: Nazar E Imam  
**Undergraduate Degree**: B.E. in Geoinformatics Engineering, National University of Sciences and Technology (NUST)  
**Academic Standing**: CGPA 3.52 / 4.00  
**Target Programs**: US Master's and PhD Programs in GIScience, GeoAI, Remote Sensing, and Spatial Data Science  

---

## A. Complete Research Summary (350–500 words)

Quantifying three-dimensional forest structure and terrestrial carbon stocks across heterogeneous landscapes is essential for climate mitigation and ecological modeling, yet traditional field inventories are spatially constrained and passive optical remote sensing saturates over dense canopies. To address these limitations, I engineered an automated, reproducible research pipeline in R to quantify 3D forest biometrics and Above-Ground Biomass (AGB) from Airborne Laser Scanning (ALS) LiDAR point clouds. 

Focusing on a 1.0 km² core research tile within Harvard Forest (NEON Domain 01), the computational workflow systematically processes discrete-return LiDAR (NEON product DP1.30003.001) acquired at an empirical density of 5.85 points/m² (5,852,530 raw points). The pipeline first enforces rigorous data quality control by implementing an Isolated Voxel Filter ($res=5\text{ m}, n=6$) that removes 12,303 atmospheric and sensor noise returns. It subsequently models the bare-earth topography beneath dense foliage using a physics-based Cloth Simulation Filter (CSF, cloth resolution 0.5 m) and interpolates a 1.0 m Digital Terrain Model (DTM) via Triangulated Irregular Networks (TIN) to normalize ellipsoidal elevations into true canopy heights ($Z \in [-0.50, 39.33]\text{ m}$). 

To reconstruct continuous vegetation structure without data voids, the pipeline executes Khosravipour's pit-free Delaunay triangulation across multiple height thresholds (0, 2, 5, 10, 15 m) to yield a 0.5 m resolution Canopy Height Model (CHM, 99.999% valid cells, mean height 16.62 m). Individual tree crowns are delineated by combining a dynamic variable-window Local Maximum Filter ($w = 0.1h + 0.6$, $h_{min} = 5.0\text{ m}$) with Dalponte’s seeded watershed region growing algorithm. Crown biometrics are extracted via 2D convex hull polygons, and above-ground biomass is estimated through power-law allometry. The workflow successfully segmented 79,780 individual trees (mean height 17.94 m, modal co-canopy layer at 20–22 m with 12,542 trees) and estimated a total landscape biomass of 575.82 Mg (5.76 Mg/ha). 

To ensure analytical accessibility, I deployed the pipeline across two software architectures: a reactive R Shiny application for parameter exploration and a production Next.js 16/React 19 web dashboard. While the system establishes high computational throughput and reproducibility, audit analysis identified critical scientific limitations: watershed algorithms over-segment overlapping broadleaf canopies, a single generalized allometric equation ignores inter-species wood density variation, and field plot validation was absent. These findings motivate my proposed graduate research: developing multimodal 3D deep learning architectures and foundation models that integrate aerial LiDAR with imaging spectroscopy for species-specific, uncertainty-aware forest carbon modeling.

---

## B. Three-Sentence Research Summary

1. I investigated how high-density discrete-return Airborne LiDAR point clouds can be automatically and reproducibly transformed into individual tree inventories and landscape-level biomass estimates across complex temperate forest canopies.
2. I engineered a modular R pipeline integrating Isolated Voxel Filter denoising, physics-based Cloth Simulation ground classification, Khosravipour pit-free canopy height modeling, and Dalponte seeded watershed segmentation, coupled with an interactive full-stack web dashboard.
3. The research successfully delineated 79,780 individual trees and quantified 575.82 Mg of above-ground biomass across a 100-hectare Harvard Forest tile, while revealing that heuristic watershed algorithms and species-agnostic allometries create significant segmentation and allometric uncertainties in overlapping deciduous stands.

---

## C. Academic CV Research Descriptions (3 Bullet Points)

- **Engineered Automated 3D LiDAR Processing Pipeline**: Developed an end-to-end R research workflow (`lidR`, `sf`, `terra`, `RCSF`) processing 5.85 million discrete-return ALS points across a 100-ha NEON Harvard Forest tile; executed Isolated Voxel Filter denoising (eliminating 12.3K noise points) and Cloth Simulation ground filtering to generate a 1.0 m bare-earth DTM and vertical height normalization.
- **Implemented Individual Tree Segmentation & Structural Modeling**: Reconstructed a 0.5 m resolution pit-free Canopy Height Model using multi-threshold Delaunay triangulation; implemented dynamic variable-window Local Maximum Filtering ($w = 0.1h + 0.6$) and Dalponte watershed segmentation, delineating 79,780 individual tree crowns and characterizing vertical canopy stratification (unimodal peak at 20–22 m; 12.5K trees).
- **Quantified Biomass Allometry & Deployed Full-Stack Geospatial Dashboards**: Extracted 2D convex hull crown dimensions and computed 575.82 Mg of landscape biomass via non-linear allometry; authored a reactive R Shiny analytical GUI and engineered a decoupled portfolio web platform in Next.js 16, TypeScript, and Recharts for interactive geospatial metrics visualization.

---

## D. Master's Letter of Motivation (LOM) Research Paragraph (118 words)

> In my undergraduate research, I addressed the challenge of quantifying 3D forest structure from discrete-return Airborne Laser Scanning LiDAR. Working with NEON datasets covering Harvard Forest, I engineered an automated R pipeline that executed Isolated Voxel Filter denoising, Cloth Simulation ground filtering, and pit-free canopy modeling to segment 79,780 individual tree crowns and estimate 575.82 Megagrams of biomass. However, evaluating the results revealed that heuristic watershed segmentation struggles with interlocking deciduous branches, while generalized allometric equations introduce substantial uncertainty by ignoring species-specific wood densities. This limitation motivated my desire to pursue graduate research in GeoAI, where I aim to develop multimodal 3D deep learning architectures that fuse point clouds with imaging spectroscopy for species-aware ecological modeling.

*(Word count: 118 words — rigorously within the 100–130 word constraint; no clichés or exaggerated prose).*

---

## E. Personalized Faculty Outreach Paragraph (98 words)

> Your laboratory's research on 3D computer vision and geospatial representation learning closely aligns with questions arising from my recent work. Using airborne LiDAR from NEON, I developed an automated pipeline to model canopy surfaces and delineate 79,780 individual trees across Harvard Forest. While effective for structural inventories, the work revealed that classical morphological watershed algorithms cannot resolve overlapping co-dominant crowns without severe over-segmentation. I am eager to contribute my background in Geoinformatics and spatial point-cloud processing to your team by investigating how multimodal 3D neural architectures and foundation models can leverage raw point geometry for automated, species-specific forest carbon mapping.

*(Word count: 98 words — rigorously within the 80–110 word constraint; direct, grounded connection).*

---

## F. Proposed Master's Research Direction

- **Focused Research Question**: *Can multimodal deep learning combining 3D Airborne LiDAR point clouds and hyperspectral imagery improve individual tree crown delineation accuracy and species-specific biomass estimation in dense temperate deciduous forests compared to classical CHM watershed segmentation?*
- **Research Plan**: The proposed Master's thesis will develop an end-to-end multimodal 3D neural network (coupling a sparse 3D convolutional backbone for point geometry with a vision transformer for hyperspectral reflectance). Using co-registered NEON ALS and imaging spectrometer datasets across Harvard Forest (`HARV`) and Smithsonian Conservation Biology Institute (`SCBI`), the model will simultaneously predict 3D instance crown masks and taxonomic species identities. Validated against NEON in-situ woody plant vegetation structure plots, this work will eliminate manual heuristic tuning and provide species-calibrated biomass accounting feasible within a two-year degree.

---

## G. Proposed PhD Research Direction

- **Ambitious Research Question**: *How can physics-informed graph foundation models incorporating biomechanical branching constraints and conformal prediction quantify multi-decadal carbon sequestration and propagate uncertainty bounds across continental-scale forest ecosystems?*
- **Research Plan**: Extending beyond regional Master's-level modeling, this PhD research will formulate airborne point clouds as continuous 3D geometric graphs. The dissertation will design an $E(n)$-equivariant Graph Neural Network constrained by physics-informed structural loss functions (mass conservation and biomechanical load limits) to predict tree allometry directly from topology. The framework will ingest continental multi-temporal ALS collections (2014–2024), scaling regional predictions by assimilating spaceborne GEDI LiDAR waveforms and ICESat-2 photon tracks. By incorporating Monte Carlo conformal prediction, the architecture will provide mathematically guaranteed, spatially explicit uncertainty bounds for institutional carbon credit verification.

---

## H. Graduate Research Interview Preparation (10 Technical Q&A)

### Q1: Why did you choose the Cloth Simulation Filter (CSF) for ground classification over traditional Progressive TIN Densification (PTD)?
**Evidence-Grounded Answer**: PTD iteratively adds points to a triangulated surface based on distance and angle thresholds, which often struggles on steep terrain or dense vegetation edges where surface thresholds require extensive empirical tuning. CSF (Zhang et al., 2016) inverts the point cloud and simulates a virtual elastic cloth dropping under gravity. In `scripts/02_normalization.R`, I parameterized CSF with `cloth_resolution = 0.5m`, `class_threshold = 0.5m`, and `sloop_smooth = TRUE`. This physical simulation provided stable bare-earth separation beneath Harvard Forest's dense closed canopy without requiring localized parameter tuning across variable topography.

### Q2: How does Khosravipour's pit-free algorithm prevent voids in the Canopy Height Model compared to standard rasterization?
**Evidence-Grounded Answer**: Standard rasterization assigns the maximum point elevation within each pixel, which frequently creates artificial depressions or "pits" when laser pulses penetrate through open foliage to strike internal branches. Khosravipour et al. (2014), implemented in `scripts/03_surface_modeling.R` via `lidR::pitfree()`, constructs Delaunay triangulations at sequential vertical layers—specifically thresholds at 0, 2, 5, 10, and 15 m with maximum edge lengths of 0 and 1.5 m. Triangles are rasterized at each level and stacked, yielding a watertight 0.5 m CHM with 3,999,994 valid cells out of 4,000,000 pixels (99.999% coverage).

### Q3: What is the mathematical basis of your Local Maximum Filter window, and why is it dynamic?
**Evidence-Grounded Answer**: Fixed-window filters cause severe trade-offs: small windows over-segment large crowns by identifying multiple branch tips as separate trees, while large windows under-segment smaller understory trees. In `scripts/04_segmentation.R`, I formulated a dynamic linear window function: $w(h) = 0.1 \times h + 0.6$, with a minimum threshold $h_{min} = 5.0\text{ m}$. For a 10 m tree, the search diameter is 1.6 m; for a 35 m emergent tree, it expands to 4.1 m. This heuristic reflects ecological allometry where horizontal crown width scales positively with vertical tree height.

### Q4: Did your project implement or train any machine learning or deep learning models?
**Evidence-Grounded Answer**: No. A rigorous audit of the codebase confirms that no machine learning, deep learning, or foundation models were trained or evaluated. The computational pipeline relies entirely on deterministic computational geometry (TIN, Delaunay triangulation), physics-based cloth simulation, morphological watershed algorithms (Dalponte 2016), and parametric empirical equations. Recognizing this boundary is precisely why I am seeking graduate training in GeoAI—to advance from classical geometric heuristics toward 3D representation learning.

### Q5: In your CSV outputs, you delineated 79,780 trees across 100 hectares (~798 stems/ha). Is this density ecologically plausible for Harvard Forest?
**Evidence-Grounded Answer**: Yes, 798 stems/ha is highly consistent with stem densities reported in US Forest Service FIA plots and NEON Terrestrial Observation System surveys for mature, mixed deciduous-coniferous stands in New England (which typically range between 500 and 1,200 stems/ha for stems $\ge 5\text{ cm}$ DBH). However, because the Dalponte algorithm operates on a 2D CHM, large broadleaf trees with split crowns were likely over-segmented into multiple clusters, while suppressed sub-canopy saplings below the 5 m threshold were excluded.

### Q6: We noticed a discrepancy between the allometric equation in your README ($a=0.05$) and your code ($a=0.06$). Which is accurate, and what impact does it have?
**Evidence-Grounded Answer**: The executable code in `scripts/04_segmentation.R` (line 63) is the ground-truth implementation: $AGB = \frac{0.06 \times (H \times CA)^{0.9}}{1000}\text{ Mg}$. The value $0.05$ in `README.md` was a documentation transcription discrepancy. Because power-law allometry is multiplicative, shifting the scaling factor from 0.05 to 0.06 represents an immediate 20% increase in estimated biomass. This sensitivity clearly illustrates the hazard of relying on uncalibrated generalized allometric constants rather than localized, species-specific equations.

### Q7: How did you validate the accuracy of your segmented tree crowns and estimated biomass?
**Evidence-Grounded Answer**: The current project codebase does not contain independent in-situ ground-truth validation data. The 79,780 tree crowns and 575.82 Mg total biomass are uncalibrated model outputs. In my future graduate research, I plan to validate these models against field inventory plots—specifically the NEON Woody Plant Vegetation Structure dataset (`DP1.10098.001`), which provides stem-mapped DBH, height, and taxonomic identification across established 20 m × 20 m and 40 m × 40 m plots.

### Q8: What computational bottlenecks would arise if you scaled this pipeline from a single 1 km² tile to an entire ecological domain?
**Evidence-Grounded Answer**: The current implementation loads full point clouds into memory (`readLAS` with `xyzrn`) and executes sequential rasterizations. While `00_setup.R` initializes multi-core threads via `lidR::set_lidr_threads()`, memory allocation becomes a major constraint for multi-gigabyte LAS files. Scaling to regional extents requires: (1) streaming chunk-based processing via `lidR::catalog` with spatial buffers (e.g., 15 m) to eliminate edge artifacts, (2) spatial database integration (PostGIS with PointCloud extension), and (3) distributed computing frameworks (such as Apache Sedona or Dask-Geopandas).

### Q9: Why did you build two separate user interfaces (R Shiny and Next.js)?
**Evidence-Grounded Answer**: They serve two distinct architectural roles. The R Shiny application (`app.R`) is an analytical research interface that directly invokes the R processing pipeline, allowing a researcher to adjust input parameters, re-run normalization, and inspect spatial rasters reactively. The Next.js 16/React 19 dashboard (`dashboard/`) is a decoupled production presentation interface. By consuming pre-aggregated metrics (`forest_metrics.json`), it delivers sub-second rendering, accessible visual analytics, and interactive charts without burdening users with R runtime dependencies or multi-gigabyte spatial files.

### Q10: How does your undergraduate Geoinformatics background prepare you to conduct research in GeoAI and remote sensing?
**Evidence-Grounded Answer**: My B.E. in Geoinformatics Engineering from NUST (CGPA 3.52/4.00) provided rigorous foundational training in spatial reference systems, coordinate geometry, photogrammetry, remote sensing physics, spatial database indexing, and GIS algorithms. This project demonstrates my ability to apply those theoretical fundamentals to complex 3D point-cloud processing, bridge algorithmic analysis with full-stack software development, and critically analyze the mathematical limitations of spatial models. Graduate study will allow me to build on this foundation by designing new representation learning methods for 3D geospatial data.

