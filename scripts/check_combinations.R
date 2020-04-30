c <- case_details_patterns$cino[case_details_patterns$pattern_flag_3 == 1][sample(2000, 1)]
a <- case_act_details$act[case_act_details$cino == c]
act_details[act_details$id %in% a,] %>% View()