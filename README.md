# 🩺 NHANES Hypertension Analysis: Uncovering Undiagnosed Risk

👉 **[Click here to view the full interactive report](https://www.google.com/search?q=https://fuaad-hassan.github.io/nhanes_hypertension_project/portfolio.html)**

---

## Overview

Millions of Americans live with high blood pressure without realizing it. This project analyzes CDC survey data from the **National Health and Nutrition Examination Survey (NHANES)** to figure out who is slipping through the cracks.

By comparing biological blood pressure readings against self-reported medical histories, I evaluate demographic patterns in hypertension and fit survey-weighted logistic regression models to identify key predictors of remaining **undiagnosed**.

---

## Key Findings

* **The Mid-Life Gap:** Overall hypertension prevalence is highest in older adults ($60+$), but the proportion of **undiagnosed cases peaks in middle-aged adults (18–59)**.
* **Age as a Predictor:** Each additional year of age slightly reduces the odds of staying undiagnosed (**OR = 0.963, p < 0.001**). This aligns with clinical intuition: older individuals interact with the healthcare system more frequently, increasing their chances of getting diagnosed.

---

## Statistical Methodology

Standard statistical methods assume simple random sampling. Because NHANES uses a complex multi-stage cluster design, applying standard standard error formulas yields biased results.

To preserve proper variance architecture:

* **Survey Design Object:** Built using `srvyr::as_survey_design()` incorporating Primary Sampling Units (`psu`), stratification (`strata`), and examination weights (`weight_mec`).
* **Domain Estimation:** Rather than subsetting the dataset before setting up the survey design (which destroys degrees of freedom and standard error estimation), subpopulations were isolated using design-aware filtering (`srvyr::filter`).

---

## Project Structure

```text
├── R/
│   ├── 01_ingest.R       # Pulls DEMO, BPX, and BPQ datasets from CDC via nhanesA
│   ├── 02_clean.R        # Cleans blood pressure metrics and constructs 4-tier status
│   ├── 03_descriptive.R  # Generates weighted population summaries and plots
│   └── 04_inferential.R  # Fits survey-weighted logistic regression models (svyglm)
├── data/                 # Raw and processed RDS files (ignored by git)
├── portfolio.qmd         # Main Quarto source document
├── index.html            # Compiled HTML report served on GitHub Pages
└── README.md

quarto render portfolio.qmd --to html

```
