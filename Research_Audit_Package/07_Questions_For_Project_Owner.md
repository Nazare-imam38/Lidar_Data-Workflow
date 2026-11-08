# 07. Unresolved Questions for Project Owner (Nazar E Imam)

This document outlines key technical, methodological, and authorship questions identified during the independent scientific audit of the *Automated 3D Forest Carbon & Biomass Analytics* workspace. To ensure your graduate school application materials (Statements of Purpose, CVs, and interview responses) are 100% accurate and defensible, please clarify the following points:

---

## 1. Project Authorship and Collaboration
- **Audit Observation**: The workspace `d:\RStudio\Lidar Data` does not contain a `.git` version control repository, meaning commit-by-commit authorship timestamps and collaborator identities are absent.
- **Clarification Needed**:
  1. Did you develop this codebase entirely independently, or was it co-developed with university peers, research supervisors, or laboratory colleagues at NUST?
  2. Was this project completed as an undergraduate capstone/final year project (FYP), an independent research initiative, a coursework assignment, or part of a professional consultancy?

---

## 2. Provenance of Allometric Biomass Equation
- **Audit Observation**: In `scripts/04_segmentation.R` (lines 63–70), above-ground biomass is computed using:
  $$AGB = \frac{0.06 \times (H \times CA)^{0.9}}{1000}\text{ Mg}$$
  Meanwhile, `README.md` (line 34) states: $AGB = 0.05 \times H^{0.9} \times CA^{0.9}$.
- **Clarification Needed**:
  1. Where did the constants $a=0.06$ (or $0.05$) and $b=0.9$ originate? Were they derived from a published forestry allometry paper (such as Jenkins et al., 2003; Chojnacky et al., 2014; or Jucker et al., 2017), or were they selected as generalized demonstration parameters?
  2. If they were adapted from a published equation, what were the original units of measurement (e.g., kg, pounds, dry matter), and for which forest type/species was it originally calibrated?

---

## 3. Ground-Truth Field Validation
- **Audit Observation**: No external ground-truth field inventory data (e.g., NEON TOS Woody Plant plots, Forest Inventory and Analysis [FIA] plots, or stem-mapped tree tags) were found in the `data/` or `outputs/` folders.
- **Clarification Needed**:
  1. Did you perform any empirical validation of individual tree counts, heights, or biomass against external field data that is not stored in this repository?
  2. If so, what were the quantitative evaluation metrics (e.g., tree detection F1-score, height estimation RMSE, or biomass $R^2$)? If not, we will maintain the documented admissions position: *"No verified quantitative performance evaluation was found."*

---

## 4. Multi-Temporal and Multi-Site Analysis
- **Audit Observation**: The project documentation and UI prominently highlight "Carbon Sequestration", which inherently requires analyzing multi-temporal change over time ($\Delta\text{Biomass}/\Delta t$). However, the data folder contains only a single 2019 tile for Harvard Forest (`HARV`).
- **Clarification Needed**:
  1. Did you execute this pipeline on other NEON acquisition years (e.g., 2018, 2021, or 2022) to compute annual biomass change or sequestration rates?
  2. Did you test the pipeline on other NEON terrestrial sites representing contrasting forest structures (e.g., Smithsonian Conservation Biology Institute `SCBI`, Ordway-Swisher `OSBS`, or Wind River `WREF`)?

---

## 5. Publication and Presentation Status
- **Audit Observation**: No formal manuscript drafts, LaTeX files, conference presentation slides, or DOI preprints were identified within the workspace.
- **Clarification Needed**:
  1. Has any part of this work been submitted, presented, or published in academic conferences (e.g., IEEE IGARSS, AAG, AGU, GIScience) or peer-reviewed journals?
  2. Has this work been shared on public preprint servers (e.g., EarthArXiv, arXiv) or presented at university symposiums?

---

## 6. Software Deployment and Web Hosting
- **Audit Observation**: The workspace contains an R Shiny app (`app.R`) and a Next.js 16/React 19 web dashboard (`dashboard/`).
- **Clarification Needed**:
  1. Are either of these dashboards deployed live on the public web (e.g., on Vercel, Netlify, shinyapps.io, or a personal server)?
  2. If a live URL exists, what is the link? Providing a live URL on your academic CV or faculty email is an exceptionally strong signal of engineering capability.

