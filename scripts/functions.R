fetch_all_tables <- function(){
  all_tables <- dbxSelect(con,
                          "SELECT table_name FROM information_schema.tables
                 WHERE table_schema='public'") 
  return(all_tables)
}


# dbxSelect(
#   con,
#   "select distinct disp_name from case_details "
# ) %>% write_clip()
