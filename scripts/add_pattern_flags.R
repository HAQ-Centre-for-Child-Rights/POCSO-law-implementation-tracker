
source("scripts/read_files.R")

# Add pattern_flags to case_details 
add_pattern_flags <- function(pattern_id){
 pattern_case_ids <- pattern_df$all_cases[pattern_df$pattern_id == pattern_id] 
 pattern_case_ids <- strsplit(pattern_case_ids, split = ",") %>% unlist() %>% unique()
 print("######################")
 print(glue("Total case IDs for pattern {pattern_id} - {length(pattern_case_ids)}"))
 case_details$pattern_flag <- 0
 case_details$pattern_flag[case_details$cino %in% pattern_case_ids] <- 1
 print(glue("Total cases flagged - {nrow(case_details[case_details$pattern_flag == 1,])}"))
 return(data.frame("pattern_flag"=case_details$pattern_flag))
}

x <- lapply(pattern_df$pattern_id, add_pattern_flags) %>% dplyr::bind_cols()
names(x)[] <- stringr::str_replace_all(names(x), pattern = "\\.\\.\\.",replacement = "_")

case_details_patterns <- dplyr::bind_cols(case_details, x)
readr::write_csv(case_details_patterns, "data/ipc_pocso_patterns/case_details_patterns.csv")
