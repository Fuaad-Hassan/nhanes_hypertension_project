library(dplyr)
library(ggplot2)
library(survey)
library(srvyr)

final_df <- readRDS("data/processed/nhanes_processed.rds")
final_df <- final_df %>%
  mutate(
    age_bracket = cut(age, breaks = c(17, 39, 59, Inf), 
                      labels = c("18-39", "40-59", "60+"))
  )

# Initialize the Complex Survey Design Object
nhanes_svy <- final_df %>%
  as_survey_design(
    ids = psu,           
    strata = strata,     
    weights = weight_mec,
    nest = TRUE          
  )
message("Survey design object initialized successfully.")

# Weighted Summary Statistics
demo_summary <- nhanes_svy %>%
  group_by(htn_status) %>%
  summarize(
    raw_count = unweighted(n()),
    pop_proportion = survey_mean(vartype = "ci"),
    mean_age = survey_mean(age, na.rm = TRUE, vartype = "ci"),
    mean_income = survey_mean(income_ratio, na.rm = TRUE, vartype = "ci")
  )

message("--- Weighted Demographic Summary by Hypertension Status ---")
print(demo_summary)

# Weighted Proportions
plot_data <- nhanes_svy %>%
  group_by(age_bracket, htn_status) %>%
  summarize(
    prop = survey_mean(), 
    .groups = "drop"
  )

# Weighted Visualization
p <- ggplot(plot_data, aes(x = age_bracket, y = prop, fill = htn_status)) +
  geom_bar(stat = "identity", position = "fill", color = "black", alpha = 0.85) +
  scale_y_continuous(labels = scales::percent_format()) +
  scale_fill_manual(
    values = c(
      "Healthy" = "#4CAF50",      
      "Managed" = "#2196F3",      
      "Uncontrolled" = "#FF9800", 
      "Undiagnosed" = "#F44336"   
    )
  ) +
  theme_minimal() +
  labs(
    title = "Hypertension Status by Age Group",
   # subtitle = "Adjusted using NHANES complex survey weights",
    x = "Age Bracket",
    y = "Weighted Proportion of Population",
    fill = "Status"
  ) +
  theme(
    plot.title = element_text(face = "bold", size = 14),
    legend.position = "bottom"
  )

print(p)