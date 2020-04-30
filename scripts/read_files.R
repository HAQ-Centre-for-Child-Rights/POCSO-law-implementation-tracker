source("scripts/libraries.R")

# 1 - Case Details
case_details <- read_csv("data/ipc_pocso_patterns/case_details.csv",
                         col_types = cols(date_of_decision = col_date(format = "%Y-%m-%d"),
                                          district_code = col_character(),
                                          dt_regis = col_date(format = "%Y-%m-%d"),
                                          state_code = col_character()))
# 2 - Act Details
act_details <- read_csv("data/ipc_pocso_patterns/act_details.csv",
                        col_types = cols(id = col_character()))

# 3 - Case Act Details
case_act_details <- read_csv("data/ipc_pocso_patterns/case_act_details.csv",
                             col_types = cols(act = col_character()))

# 4 - Pattern dataframe
pattern_df <- pattern_df <- read_csv("data/ipc_pocso_patterns/pattern_df.csv",
                                     col_types = cols(pattern_id = col_character()))