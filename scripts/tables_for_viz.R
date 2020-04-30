source("scripts/read_files.R")

act_case_agg <- case_act_details %>% group_by(act) %>% summarise(total_cases = length(cino))
act_details_cases <- left_join(act_details, act_case_agg, by=c('id'='act'))
readr::write_csv(act_details_cases, "data/ipc_pocso_patterns/act_detail_cases.csv")
