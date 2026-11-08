# 04. Future Research Questions and Proposed Research Agendas

**Author**: Nazar E Imam  
**Academic Background**: B.E. Geoinformatics Engineering, NUST (CGPA: 3.52/4.00)  
**Research Domain**: GeoAI, 3D Computer Vision, Forestry Remote Sensing, Spatiotemporal Data Science  

The three research questions developed below emerge directly from the empirical findings, algorithmic limitations, and unvalidated assumptions identified in the audit of the *Automated 3D Forest Carbon & Biomass Analytics* project.

---

## Research Question 1: Multimodal 3D Deep Learning for Tree Delineation and Species-Specific Allometry

### Central Research Question (One Sentence)
> **Can multimodal deep learning architectures combining discrete 3D Airborne LiDAR point clouds with high-resolution imaging spectroscopy significantly resolve canopy overlapping errors in dense temperate deciduous forests to improve individual tree crown delineation and species-specific biomass accuracy over classical watershed segmentation?**

1. **Specific Problem**: The current project relies on a 2D pit-free Canopy Height Model coupled with the Dalponte (2016) seeded watershed segmentation. In closed-canopy, multi-layered broadleaf forests (such as Harvard Forest), co-dominant crowns overlap and interlock extensively, causing watershed algorithms to over-segment large branching crowns into multiple false stems and under-segment sub-canopy trees. Furthermore, the absence of species identification forces the use of a single uniform allometric parameter ($a=0.06$), ignoring species-dependent wood density variations.
2. **Motivating Project Finding**: The project detected 79,780 trees across 100 hectares (~798 stems/ha) with an average crown area of only 10.01 m², exhibiting extreme crown fragmentation in deciduous canopies and an unvalidated 20% biomass shift between documentation ($a=0.05$) and implementation ($a=0.06$).
3. **Scientific Importance**: Accurate forest carbon accounting requires species-specific wood specific gravity (e.g., *Quercus rubra* at 0.63 g/cm³ vs. *Pinus strobus* at 0.35 g/cm³). Without species classification, landscape-level carbon estimates carry systematic biases exceeding 30–40%.
4. **Proposed Approach**: Develop an end-to-end multimodal 3D deep neural network (e.g., coupling a sparse 3D convolutional backbone like MinkowskiNet/PointNet++ with a 2D vision transformer backbone for hyperspectral reflectance). The network will simultaneously predict: (a) 3D instance masks for individual crowns directly from raw point geometry, and (b) taxonomic tree species classes from spectral absorption features (water, lignin, cellulose).
5. **Target Datasets**: NEON AOP co-registered Discrete Return LiDAR (`DP1.30003.001`) and Imaging Spectrometer Surface Directional Reflectance (`DP1.30006.001`) over Harvard Forest (`HARV`) and Smithsonian Conservation Biology Institute (`SCBI`), combined with NEON Terrestrial Observation System (TOS) Woody Plant Vegetation Structure ground plots (`DP1.10098.001`).
6. **Testable Hypothesis**: Directly segmenting 3D point cloud topology with multimodal spectral-spatial feature fusion will increase tree detection F1-score by at least 15% in dense deciduous canopies compared to classical CHM watershed segmentation, while reducing species-weighted biomass estimation error (RMSE) by over 25% against field plot measurements.
7. **Evaluation Strategy**: Benchmarking against georeferenced NEON ground-truth forest inventory plots using intersection-over-union (IoU) crown overlap, precision-recall-F1 for stem detection, and root mean square error (RMSE) for plot-aggregated biomass.
8. **Expected Research Contribution**: A novel multimodal GeoAI instance segmentation framework that replaces heuristic 2D CHM watershed filters with direct 3D geometric-spectral representation learning.
9. **Master's Thesis Suitability**: Highly feasible for a 2-year Master's thesis focusing on model development, spectral-spatial feature fusion, and validation on 2–3 NEON forest domains.
10. **PhD Extension**: Expand into a generalized Geospatial Foundation Model for continental-scale forestry that zero-shot transfers across diverse biomes without retraining.

---

## Research Question 2: Multi-Temporal 4D Spatiotemporal Modeling of Carbon Sequestration and Canopy Gap Dynamics

### Central Research Question (One Sentence)
> **How can multi-temporal airborne laser scanning time-series be integrated with spaceborne GEDI LiDAR waveforms to model 4D canopy structural dynamics, natural disturbance gap recovery, and annual net carbon sequestration rates while rigorously quantifying spatial registration and phenological uncertainties?**

1. **Specific Problem**: The audited project processes a single temporal snapshot (2019), preventing any empirical verification of actual carbon *sequestration* rates ($\Delta\text{Biomass}/\Delta t$). True ecological monitoring requires capturing subtle vertical growth (0.2–0.8 m/yr), natural mortality, and gap formation over time.
2. **Motivating Project Finding**: The project framework is structurally limited to single-tile static processing, leaving the core claim in its title—"Carbon Sequestration"—entirely unquantified.
3. **Scientific Importance**: Quantifying whether temperate forests remain net carbon sinks under accelerating climate change, pest outbreaks (e.g., Hemlock Woolly Adelgid at Harvard Forest), and extreme weather requires robust, multi-epoch 4D structural change detection that disentangles true ecological growth from sensor flight-line misalignments.
4. **Proposed Approach**: Construct a spatiotemporal 4D point-cloud change detection pipeline. Utilize Bayesian strip-adjustment and 3D Coherent Point Drift (CPD) to co-register multi-year ALS acquisitions (2014, 2018, 2019, 2022). Apply 4D spatiotemporal Gaussian Processes to interpolate vertical growth and gap dynamics, scaling regional estimates by integrating spaceborne GEDI (Global Ecosystem Dynamics Investigation) full-waveform LiDAR metrics.
5. **Target Datasets**: Multi-year NEON AOP ALS campaigns for `HARV` (2014–2024), NASA GEDI L2A/L2B canopy profile footprints, and Harvard Forest Long-Term Ecological Research (LTER) core flux tower biometric measurements.
6. **Testable Hypothesis**: Spatiotemporal alignment of repeat ALS point clouds using non-rigid 3D point-drift registration enables detection of sub-meter annual canopy increments ($\ge 0.25\text{ m}$) with statistical significance ($p < 0.01$), establishing annual net carbon sequestration rates that match eddy-covariance flux tower measurements within a 10% error margin.
7. **Evaluation Strategy**: Compare LiDAR-derived biomass growth increments against continuous net ecosystem exchange (NEE) data from the Harvard Forest Environmental Measurement Station (EMS) eddy covariance tower.
8. **Expected Research Contribution**: An uncertainty-aware 4D spatiotemporal analytical framework capable of distinguishing genuine silvicultural biomass accumulation from phenological and flight-line sensor errors.
9. **Master's Thesis Suitability**: Feasible for a Master's thesis focusing on dual-epoch ALS change detection and comparison against annual tree-ring or flux tower records across Harvard Forest.
10. **PhD Extension**: Scale the spatiotemporal framework to fuse multi-decadal airborne ALS with ICESat-2 photon-counting and GEDI spaceborne waveforms across continental biomes.

---

## Research Question 3: Scalable Graph Foundation Models and Physics-Informed Uncertainty Quantification for Biomass Estimation

### Central Research Question (One Sentence)
> **Can graph neural networks incorporating physics-informed allometric constraints and Monte Carlo conformal prediction propagate point-to-landscape uncertainty bounds in continental-scale forest biomass accounting?**

1. **Specific Problem**: Current biomass estimation cascades deterministic equations across multiple uncertain processing stages (raw sensor noise → ground interpolation error → crown boundary delineation error → uncalibrated power-law allometry). Neither the audited project nor standard forestry pipelines provide confidence intervals or spatially explicit uncertainty quantification for their carbon estimates.
2. **Motivating Project Finding**: The audited project generates deterministic single-value outputs (e.g., exactly "575.82 Mg" biomass across 79,780 trees) despite clear evidence of sensor noise (12,303 filtered points) and heuristic segmentation parameters, producing an illusion of absolute measurement certainty.
3. **Scientific Importance**: As carbon markets and United Nations REDD+ programs transition to financial crediting, institutional buyers require verifiable confidence bounds (e.g., 90% or 95% credibility intervals). Estimating biomass without rigorous uncertainty quantification exposes conservation investments to severe financial and ecological risk.
4. **Proposed Approach**: Formulate forest point clouds as large-scale dynamic geometric graphs (nodes = tree returns, edges = 3D spatial adjacency). Train an $E(n)$-equivariant Graph Neural Network (GNN) constrained by physics-informed structural loss functions (conservation of mass and biomechanical branching limits). Couple this with conformal prediction and Bayesian deep learning to output spatially explicit prediction intervals for biomass at every pixel.
5. **Target Datasets**: The complete NEON AOP LiDAR archive spanning 47 terrestrial sites across the United States, validated against the US Forest Service Forest Inventory and Analysis (FIA) database and terrestrial laser scanning (TLS) 3D tree reconstructions.
6. **Testable Hypothesis**: Physics-informed graph neural networks constrained by structural biomechanics produce biomass estimates that reduce landscape-level uncertainty intervals by 35% compared to unconstrained empirical models, while providing mathematically guaranteed coverage rates for carbon credit verification.
7. **Evaluation Strategy**: Evaluate prediction interval coverage probability (PICP), mean prediction interval width (MPIW), and out-of-distribution transferability across contrasting ecological biomes (e.g., eastern deciduous vs. western coniferous vs. tropical rainforest).
8. **Expected Research Contribution**: The first physics-informed, uncertainty-calibrated GeoAI framework for continental-scale forestry, establishing a new paradigm for trustworthy, auditable remote sensing carbon accounting.
9. **Master's Thesis Suitability**: Feasible for a research Master's focusing on graph neural network architecture design, conformal prediction, and evaluation across two contrasting NEON biomes.
10. **PhD Extension**: Formulate a comprehensive PhD dissertation advancing scalable spatial computing systems, geometric representation learning, and autonomous carbon verification engines.

