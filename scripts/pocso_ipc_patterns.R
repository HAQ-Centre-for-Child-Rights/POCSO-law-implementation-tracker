source("scripts/connect_db.R")

# Data poionts for visualisations - https://docs.google.com/document/d/1Z57KuQXHSyXqU5cxEvK5eHuSnU5SvW-1RgW77jCTnQM/edit#

# Sample Queries

# 1 - List all tables ('https://stackoverflow.com/questions/43720911/list-tables-within-a-postgres-schema-using-r')

dbxSelect(con,
          "SELECT table_name FROM information_schema.tables
                 WHERE table_schema='public'") %>% View()

table_name <- "case_acts"
dbxSelect(con,
          glue::glue("SELECT * from {table_name} limit 5")) %>% View()

dbxSelect(con,
          glue::glue("SELECT count(distinct cino) from {table_name} limit 5")) %>% View()

# Get acts for all cases

all_acts <- dbxSelect(con,
                      "SELECT * from act")
all_case_acts <- dbxSelect(con,
                           "SELECT * from case_acts")

ipc_patterns <- c("1 Indian Penal Code", "1Indian Penal Code", "Indian Penal Code", "INDIAN PENAL CODE", "Indian Penal Code, 1860", "IPC", "I.P.C(Police)", "I.P.CPolice")
pocso_patterns <- c("5Protection of children from sexual offence act 2012", "POCSO", "POCSO  Protection of Children from sexual offences Act , 2012", "Pocso 2012", "POCSO Act", "POCSO ACT", "POCSO Act 2012", "POSCO Act", "Prevention Of Child Sexual Offence", "Prevention of Children from Sexual Offences Act", "PREVENTION OF CHILDREN FROM SEXUAL OFFENCES ACT", "Protection of Child from Sexual Offence Act-2012", "Protection of Child from Sexual Offences Act 2012", "Protection of Child Sexual Ofences", "Protection of Child Sexual Offece", "Protection of Childern Sexual Offence Act 2012", "Protection of Children", "Protection of Children  from Sexual offence , POCSO", "Protection of Children from Sexual  offence Act 2012", "Protection of children from sexual offence", "Protection of children from Sexual Offence", "Protection of Children from Sexual Offence", "Protection of Children from Sexual offence  Act POCSO2013", "Protection of Children from sexual offence Act", "Protection of children from sexual offence act 2012", "Protection of Children from Sexual Offence Act 2012", "Protection of Children From Sexual Offence Act 2012", "Protection of Children from Sexual offence Act, 2012", "Protection of Children from Sexual Offence Act, 2012", "Protection of Children from Sexual Offence Act,2012", "Protection of Children from Sexual Offences", "Protection of Children from Sexual Offences (POCSO)", "Protection of Children from Sexual Offences 2012", "Protection of children from sexual offences Act", "Protection of Children From Sexual Offences Act", "Protection of Children from sexual offences Act , 2012", "Protection of Children from Sexual Offences Act (POCSO)", "Protection of Children from Sexual Offences Act 2012", "Protection of Children from Sexual offences Act, 2012", "Protection of Children from Sexual Offences Act, 2012", "Protection Of Children From Sexual Offences Act, 2012 POCSO", "Protection of Children from Sexual Offences Act, 2012.", "Protection of Children from Sexual Offences Act,2012", "Protection of Children from Sexual Offences Act'2012", "Protection of Children from Sexual Offences Rules", "Protection of Children from Sexual Offencess Act", "Protection of Children from Sexual Offenses Act, 2012", "Protection of Children from Sexual Officences Act, 2012", "Protection of Children from the Sexual Offences Act, 2012", "The Protection of Children from Sexual Offence Act, 2012", "The Protection of Children from Sexual Offences Act 2012", "THE PROTECTION OF CHILDREN FROM SEXUAL OFFENCES ACT 2012", "The Protection of Children from Sexual Offences Act, 2012")
crpc_patterns <- c("Code of Civil Procedure", "CODE OF CIVIL PROCEDURE", "Code of Criminal Procedure", "CODE OF CRIMINAL PROCEDURE", "Code of Criminal Procedure, 1973", "Cr. P. C.", "Cr. P.C.", "Cr.P.c")
jj_act_patterns <- c("Juvenile Justice (Care and Protection of Children) Act", "JUVENILE JUSTICE (CARE AND PROTECTION OF CHILDREN) ACT", "Juvenile Justice (Care and protection of children) Act, 2015", "Juvenile Justice Amended Act, 2006", "Juvenile Justice Care and Protection of Children Act")
sc_st_act_patterns <- c("SC/ST Prevention of Attrocities Act 1989", "SC/ST(Prevention of attrocities) Act 1989", "Scheduled Areas (Assimilation of Laws) Act", "Scheduled Castes and Scheduled Tribes Orders (Amendment)  Act", "Scheduled Castes and Scheduled Tribes Orders (Amendment) Act", "Scheduled Castes and Scheduled Tribes Orders Amendment  Act", "Scheduled Castes and the Scheduled Tribes (Prevention of  Atrocities) Act", "Scheduled Castes and the Scheduled Tribes (Prevention of Atrocities) Act", "Scheduled Castes and the Scheduled Tribes Prevention of  Atrocities Act")
 
all_acts$act_name_std[all_acts$name %in% ipc_patterns] <- 'Indian Penal Code'
all_acts$act_name_std[all_acts$name %in% pocso_patterns] <- 'POCSO'

## Standardising acts and sections
case_number_act <- dbxSelect(con,
                             glue::glue("SELECT act, count(act) from case_acts group by act"))
case_number_act <- case_number_act %>% mutate(percent_cases = count/sum(count)*100)
case_number_act$act_std <- 0
case_number_act$act_std[case_number_act$count >= 100] <- 1
acts_to_std <- case_number_act$act[case_number_act$act_std == 1] %>% unique()

all_acts_sub <- all_acts[all_acts$id %in% acts_to_std,]
ipc_366A_patterns <- c("366-A", "366(A)", "366A")
ipc_34_patterns <- c("34", "34IPC")
ipc_120B_patterns <- c("120(B)", "120B")
ipc_354A_patterns <- c("354-A", "354(A)", "354A")

all_acts_sub$section_name_std <- all_acts_sub$section
all_acts_sub$section_name_std[all_acts_sub$section %in% ipc_366A_patterns] <- '366 A'
all_acts_sub$section_name_std[all_acts_sub$section %in% ipc_34_patterns] <- '34 A'
all_acts_sub$section_name_std[all_acts_sub$section %in% ipc_120B_patterns] <- '120 B'
all_acts_sub$section_name_std[all_acts_sub$section %in% ipc_354A_patterns] <- '354 A'

all_acts_sub$section_name_std[all_acts_sub$section == '06POCSOACT'] <- 6
all_acts_sub$section_name_std[all_acts_sub$section == '12POCSOACT'] <- 12
all_acts_sub$act_name_std[all_acts_sub$act_name_std == 'POCSO' & all_acts_sub$section %in% c("354", "363", "376")
] <- 'Indian Penal Code'

all_acts_sub <- all_acts_sub[!is.na(all_acts_sub$act_name_std),]

# How many cases are covered by these acts
total_cases <- length(unique(all_case_acts$cino))
cases_to_consider <- all_case_acts$cino[all_case_acts$act %in% all_acts_sub$id] %>% unique()
cases_covered <- length(cases_to_consider)/total_cases
# This covers ~92% (33,218) of the cases from three states

cols_to_get <- c("cino", "state_code","state_name","district_code","district_name","reg_year","fil_year","fir_year","police_station","type_name","disp_name","disp_nature","dt_regis","date_of_decision","court_name")
case_universe <- dbxSelect(con,glue::glue("Select cino,state_code,state_name,district_code,district_name,reg_year,fil_year,fir_year,police_station,type_name,disp_name,disp_nature,dt_regis,date_of_decision,court_name from case_details"))
case_subset <- case_universe[case_universe$cino %in% cases_to_consider,]
case_act_subset <- all_case_acts[all_case_acts$cino %in% cases_to_consider,]

# For Visualisations:

# 1 -  Section 4 POCSO r/w 377 IPC
pocso_id <- all_acts_sub$id[all_acts_sub$act_name_std=="POCSO" & all_acts_sub$section_name_std == "4"] %>% unique()
ipc_id <- all_acts_sub$id[all_acts_sub$act_name_std=="Indian Penal Code" & all_acts_sub$section_name_std == "377"] %>% unique()

pocso_cases <- case_act_subset$cino[case_act_subset$act %in% pocso_id] %>% unique()
ipc_cases <- case_act_subset$cino[case_act_subset$act %in% ipc_id] %>% unique()
common_cases <- intersect(common_cases,ipc_cases)
case_details <- case_subset[case_subset$cino %in% common_cases,]

