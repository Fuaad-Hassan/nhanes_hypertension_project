library(dplyr)
library(tidyr)

processed_dir <- "data/processed"
if (!dir.exists(processed_dir)) dir.create(processed_dir, recursive = TRUE, showWarnings = FALSE)

demo_raw <- readRDS("data/raw/DEMO_J.rds")
bpx_raw <- readRDS("data/raw/BPX_J.rds")
bpq_raw <- readRDS("data/raw/BPQ_J.rds")

demo_clean <- demo_raw %>%
  select(
    SEQN, 
    age = RIDAGEYR, 
    gender = RIAGENDR, 
    income_ratio = INDFMPIR,
    weight_mec = WTMEC2YR,   
    psu = SDMVPSU,          
    strata = SDMVSTRA        
  ) %>%
  filter(age >= 18) 

bpx_clean <- bpx_raw %>%
  select(SEQN, BPXSY1, BPXSY2, BPXSY3, BPXDI1, BPXDI2, BPXDI3) %>%
  rowwise() %>% 
  mutate(
    mean_sys = mean(c_across(BPXSY1:BPXSY3), na.rm = TRUE),
    mean_dia = mean(c_across(BPXDI1:BPXDI3), na.rm = TRUE)
  ) %>%
  ungroup() %>%
  select(SEQN, mean_sys, mean_dia) %>%
  filter(!is.nan(mean_sys) & !is.nan(mean_dia))

bpq_clean <- bpq_raw %>%
  select(
    SEQN, 
    told_high_bp = BPQ020
  ) %>%
  filter(told_high_bp %in% c("Yes", "No"))

final_df <- demo_clean %>%
  inner_join(bpx_clean, by = "SEQN") %>%
  inner_join(bpq_clean, by = "SEQN") %>%
  mutate(
    is_biological_htn = (mean_sys >= 130 | mean_dia >= 80),
    is_diagnosed = (told_high_bp == "Yes"),
    htn_status = case_when(
      is_biological_htn == FALSE & is_diagnosed == FALSE ~ "Healthy",
      is_biological_htn == FALSE & is_diagnosed == TRUE  ~ "Managed",
      is_biological_htn == TRUE  & is_diagnosed == TRUE  ~ "Uncontrolled",
      is_biological_htn == TRUE  & is_diagnosed == FALSE ~ "Undiagnosed",
      TRUE ~ NA_character_
    ),

    htn_status = factor(htn_status, levels = c("Healthy", "Managed", "Uncontrolled", "Undiagnosed"))
  ) %>%
  filter(!is.na(htn_status))
saveRDS(final_df, file.path(processed_dir, "nhanes_processed.rds"))
message(sprintf("Cleaning complete. Processed %d adult records.", nrow(final_df)))