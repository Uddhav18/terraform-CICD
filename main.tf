############################################
# ROLE
############################################

resource "snowflake_account_role" "etl_role" {
  name = "ETL_ROLE"
}

############################################
# WAREHOUSE
############################################

resource "snowflake_warehouse" "etl_wh" {
  name           = "ETL_WH"
  warehouse_size = "XSMALL"
  auto_suspend   = 60
}

############################################
# DATABASE
############################################

resource "snowflake_database" "etl_db" {
  name = "ETL_DB"
}

############################################
# SCHEMA
############################################

resource "snowflake_schema" "raw_schema" {
  database = snowflake_database.etl_db.name
  name     = "RAW"
}

############################################
# TABLE
############################################

resource "snowflake_table" "employee" {
  database = snowflake_database.etl_db.name
  schema   = snowflake_schema.raw_schema.name
  name     = "EMPLOYEE"

  column {
    name = "EMP_ID"
    type = "NUMBER"
  }

  column {
    name = "EMP_NAME"
    type = "VARCHAR"
  }

  column {
    name = "SALARY"
    type = "NUMBER"
  }
}

############################################
# STAGE
############################################

resource "snowflake_stage" "employee_stage" {
  name     = "EMPLOYEE_STAGE"
  database = snowflake_database.etl_db.name
  schema   = snowflake_schema.raw_schema.name
}

############################################
# STREAM
############################################

resource "snowflake_stream" "employee_stream" {
  name     = "EMPLOYEE_STREAM"
  database = snowflake_database.etl_db.name
  schema   = snowflake_schema.raw_schema.name

  on_table = snowflake_table.employee.fully_qualified_name
}

############################################
# TASK
############################################

resource "snowflake_task" "employee_task" {
  name      = "EMPLOYEE_TASK"
  database  = snowflake_database.etl_db.name
  schema    = snowflake_schema.raw_schema.name
  warehouse = snowflake_warehouse.etl_wh.name

  started = false

  schedule {
    using_cron = "0 * * * * UTC"
  }

  sql_statement = <<EOT
INSERT INTO ETL_DB.RAW.EMPLOYEE
VALUES (1,'TEST_EMP',10000);
EOT
}