source("scripts/libraries.R")

db <- Sys.getenv("db_name")
host_db <- Sys.getenv("host_db")
db_port <- Sys.getenv("db_port")
db_user <- Sys.getenv("postgres_user")
db_password <- Sys.getenv("postgres_pwd")

con <-
  dbxConnect(adapter = "postgres",
    dbname = db,
    host = host_db,
    port = db_port,
    user = db_user,
    password = db_password
  )

# Sample Queries

# 1 - List all tables ('https://stackoverflow.com/questions/43720911/list-tables-within-a-postgres-schema-using-r')
# case_details <-
#   dbxSelect(con,
#             "SELECT table_name FROM information_schema.tables
#                    WHERE table_schema='public'")