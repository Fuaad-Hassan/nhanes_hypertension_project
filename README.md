# 🩺 NHANES Hypertension Analysis: Uncovering Undiagnosed Risk

![R](https://img.shields.io/badge/R-4.3+-276DC3.svg)
![Quarto](https://img.shields.io/badge/Quarto-1.3+-75AADB.svg)
![Domain](https://img.shields.io/badge/Domain-Public_Health_&_Epidemiology-green.svg)

An end-to-end data science pipeline analyzing complex survey data from the **National Health and Nutrition Examination Survey (NHANES)** to evaluate demographic trends in hypertension and model predictors of remaining **undiagnosed**.

🔗 **[View Live Interactive Report Here](https://YOUR-GITHUB-USERNAME.github.io/YOUR-REPO-NAME/)**

---

## 📌 Executive Summary
Hypertension is a primary driver of cardiovascular disease, yet millions remain undiagnosed. This project ingests CDC/NHANES survey data, adjusts for complex survey sampling design (`PSUs`, `Strata`, and `MEC weights`), and fits a survey-weighted logistic regression model to identify key demographics at risk of under-diagnosis.

### Key Insights
* **Age Dynamics:** Older adults have a higher overall prevalence of hypertension, but **middle-aged adults (18–59)** exhibit the highest proportion of *undiagnosed* cases.
* **Predictive Drivers:** Survey-adjusted logistic regression shows that each additional year of age reduces the odds of remaining undiagnosed (**OR = 0.963, p < 0.001**), likely due to increased healthcare interaction frequency.

---

## 🛠️ Methodological Highlights: Complex Survey Weights
A critical highlight of this project is the adherence to survey statistical theory:
* **Domain Estimation:** Rather than filtering the raw dataset prior to analysis (which destroys variance structure), the full dataset is initialized into a survey design object using `srvyr::as_survey_design()`. Subpopulations are isolated using `srvyr::filter()` to preserve full PSU and Strata variance architecture.

---

## 📂 Repository Structure

```text
├── R/
│   ├── 01_ingest.R        
│   ├── 02_clean.R        
│   ├── 03_descriptive.R    
│   └── 04_inferential.R  
├── data/                  
├── portfolio.qmd         
├── index.html           
└── README.md
