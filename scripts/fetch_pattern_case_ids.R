source("scripts/libraries.R")
source("scripts/read_files.R")

pattern_df <- data.frame('act_1' = c("POCSO - 4", "POCSO - 4", "POCSO - 4","POCSO - 4", "POCSO - 4", "POCSO - 10","POCSO - 10","POCSO - 10","POCSO - 10"),
                         'act_2' = c("IPC - 377", "IPC - 366", "IPC - 366 A","IPC - 370", "IPC - 34 A", "IPC - 354","IPC - 354 A","IPC - 354D","IPC - 354B"),
                         'act_3' = c("POCSO - 6", "POCSO - 6", "POCSO - 6","POCSO - 6", "POCSO - 6","","","",""),
                         'act_4' = c("","","","","IPC - 120 B","","","",""), stringsAsFactors = FALSE)
pattern_df$pattern_id <- 1:nrow(pattern_df)

# Get case ids for respective patterns
get_case_ids <- function(pattern_id){
  pattern_row <- pattern_df[pattern_df$pattern_id == pattern_id,]
  act_1 <- act_details$id[act_details$act_section == pattern_row$act_1] %>% unique()
  act_2 <- act_details$id[act_details$act_section == pattern_row$act_2] %>% unique()
  act_3 <- act_details$id[act_details$act_section == pattern_row$act_3] %>% unique()
  act_4 <- act_details$id[act_details$act_section == pattern_row$act_4] %>% unique()
  
  act_1_cases <- case_act_details$cino[case_act_details$act %in% act_1] %>% unique()
  act_2_cases <- case_act_details$cino[case_act_details$act %in% act_2] %>% unique()
  act_3_cases <- case_act_details$cino[case_act_details$act %in% act_3] %>% unique()
  act_4_cases <- case_act_details$cino[case_act_details$act %in% act_4] %>% unique()
  
  group_1 <- c(act_1_cases,act_3_cases) %>% unique()
  group_2 <- c(act_2_cases,act_4_cases) %>% unique()
  
  common_cases <- intersect(group_1,group_2)
  
  print(glue("Total cases in Pattern - {pattern_id} - {length(common_cases)}"))
  pattern_row$all_cases <- paste0(common_cases,collapse = ",")
  return(pattern_row)
}

pattern_list <- lapply(pattern_df$pattern_id, get_case_ids) %>% dplyr::bind_rows()
pattern_list <- pattern_list[pattern_list$all_cases!='',]
readr::write_csv(pattern_list, "data/ipc_pocso_patterns/pattern_df.csv")

# # Export case_details for only pattern specific cases
# all_unique_case_ids <- strsplit(pattern_list$all_cases,split = ",") %>% unlist() %>% unique() 
# case_details_pattern <- case_details[case_details$cino %in% all_unique_case_ids,]
# readr::write_csv(case_details_pattern, "data/ipc_pocso_patterns/pattern_case_details.csv")

