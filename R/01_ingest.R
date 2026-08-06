library(nhanesA)
library(dplyr)

cycle <- "_J"
tables_to_fetch <- c(
  demo = paste0("DEMO", cycle),
  bp_exam = paste0("BPX", cycle),
  bp_quest = paste0("BPQ", cycle)
)

raw_data_dir <- "data/raw"
if (!dir.exists(raw_data_dir)) {
  dir.create(raw_data_dir, recursive = TRUE, showWarnings = FALSE)
  message(sprintf("Created directory: %s", raw_data_dir))
}

nhanes_raw_data <- list()

for (table_name in names(tables_to_fetch)) {
  api_table_code <- tables_to_fetch[[table_name]]
  file_path <- file.path(raw_data_dir, paste0(api_table_code, ".rds"))
  
  if (!file.exists(file_path)) {
    message(sprintf("Fetching %s from CDC API...", api_table_code))
    
    tryCatch({
      raw_df <- nhanes(api_table_code)
      clean_df <- nhanesTranslate(api_table_code, names(raw_df), data = raw_df)

      saveRDS(clean_df, file_path)
      nhanes_raw_data[[table_name]] <- clean_df
      
      message(sprintf("Successfully saved %s to %s", api_table_code, file_path))
      
    }, error = function(e) {
      warning(sprintf("Failed to fetch %s. Error: %s", api_table_code, e$message))
    })
    Sys.sleep(2) 
    
  } else {
    message(sprintf("Loading %s from local cache...", api_table_code))
    nhanes_raw_data[[table_name]] <- readRDS(file_path)
  }
}

message("Ingestion phase complete.")