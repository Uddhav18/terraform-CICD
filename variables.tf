variable "snowflake_organization_name" {
  type = string
}

variable "snowflake_account_name" {
  type = string
}

variable "snowflake_user" {
  type = string
}

variable "snowflake_password" {
  type      = string
  sensitive = true
}

variable "snowflake_role" {
  type = string
}

variable "snowflake_warehouse" {
  type = string
}

variable "environment" {
  type = string
}

resource "snowflake_database" "db" {
  name = "${var.environment}_DB"
}