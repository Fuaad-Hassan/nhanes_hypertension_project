library(dplyr)
library(survey)
library(srvyr)
library(broom)
library(ggplot2)

final_df <- readRDS("data/processed/nhanes_processed.rds")
df_prepared <- final_df %>%
  mutate(
    undiagnosed_flag = factor(
      ifelse(htn_status == "Undiagnosed", "Undiagnosed", "Diagnosed"),
      levels = c("Diagnosed", "Undiagnosed")
    )
  )

full_svy <- df_prepared %>%
  as_survey_design(
    ids = psu,
    strata = strata,
    weights = weight_mec,
    nest = TRUE
  )
htn_svy <- full_svy %>%
  filter(is_biological_htn == TRUE)
model_svy <- svyglm(
  undiagnosed_flag ~ age + gender + income_ratio,
  design = htn_svy,
  family = quasibinomial()
)

model_results <- tidy(model_svy, exponentiate = TRUE, conf.int = TRUE)
message("--- Inferential Model Results ---")
print(model_results)

# Forest Plot
plot_data <- model_results %>% 
  filter(term != "(Intercept)") %>%
  mutate(
    term = case_when(
      term == "age"          ~ "Age (per year)",
      term == "genderFemale" ~ "Female (vs. Male)",
      term == "income_ratio" ~ "Poverty-Income Ratio",
      TRUE ~ term
    )
  )
p_forest <- ggplot(plot_data, aes(x = estimate, y = term)) +
  geom_vline(xintercept = 1, linetype = "dashed", color = "red", linewidth = 1) +
  geom_errorbar(aes(xmin = conf.low, xmax = conf.high), width = 0.2, color = "#333333") +
  geom_point(size = 4, color = "#2196F3") +
  scale_y_discrete(expand = expansion(mult = c(0.25, 0.25))) + 
  
  theme_minimal() +
  labs(
    title = "Predictors of Remaining Undiagnosed with Hypertension",
    subtitle = "Odds Ratios with 95% Confidence Intervals",
    x = "OR > 1 means higher risk of being undiagnosed",
    y = "Predictor Variable"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    subtitle = element_text(size = 11),
    axis.text.y = element_text(size = 11, face = "bold"),
    axis.title.y = element_text(size = 12, face = "bold", margin = margin(r = 15)),
    axis.title.x = element_text(size = 11, margin = margin(t = 10))
  )

print(p_forest)