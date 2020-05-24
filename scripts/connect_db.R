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