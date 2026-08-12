# 🩺 NHANES Hypertension Analysis: Uncovering Undiagnosed Risk

👉 **[Click here to view the full interactive report](https://fuaad-hassan.github.io/nhanes_hypertension_project/portfolio.html)**

## Overview
An analysis of CDC data from the National Health and Nutrition Examination Survey (NHANES) to identify demographic predictors of undiagnosed hypertension. This project compares clinical blood pressure measurements against self-reported medical histories and utilizes survey-weighted logistic regression to evaluate variance across demographics.

## Key Findings
* **Prevalence vs. Diagnosis:** While overall hypertension prevalence is highest in adults aged 60+, the highest proportion of *undiagnosed* cases is concentrated in the 18–59 age bracket.
* **Age as a Predictor:** Increased age negatively correlates with the likelihood of remaining undiagnosed (OR = 0.963, p < 0.001), reflecting higher healthcare interaction rates among older populations.

## Statistical Methodology
NHANES utilizes a multi-stage cluster design, rendering standard simple random sampling formulas invalid for variance estimation. This analysis accounts for survey architecture via the following:

* **Survey Design Object:** Constructed using `srvyr::as_survey_design()`, explicitly defining Primary Sampling Units (`psu`), stratification variables (`strata`), and examination weights (`weight_mec`).
* **Domain Estimation:** To preserve accurate degrees of freedom and standard error estimations, subpopulations were isolated using design-aware filtering (`srvyr::filter`) rather than standard dataset subsetting.

## Project Structure

```text
├── R/
│   ├── 01_ingest.R       # Pulls DEMO, BPX, and BPQ datasets from CDC via nhanesA
│   ├── 02_clean.R        # Cleans blood pressure metrics and constructs 4-tier status
│   ├── 03_descriptive.R  # Generates weighted population summaries and plots
│   └── 04_inferential.R  # Fits survey-weighted logistic regression models (svyglm)
├── data/                 # Raw and processed RDS files (ignored by git)
├── portfolio.qmd         # Main Quarto source document
├── index.html            # Compiled HTML report served on GitHub Pages
└── README.md
```

## Quickstart

To reproduce this analysis locally:

1. **Clone the repository:**
   ```bash
   git clone https://github.com/Fuaad-Hassan/nhanes_hypertension_project.git
   cd nhanes_hypertension_project
```

2. **Restore dependencies:**
```R
renv::restore()
```

3. **Render the report:**
```bash
quarto render portfolio.qmd --to html 
```
