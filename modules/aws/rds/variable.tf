variable "rds" {
  type = map(string)

  default = {
    "default.name"           = "prod-database"
    "stg.name"               = "stg-database"
    "dev.name"               = "dev-database"
    "default.engine"         = "aurora-mysql"
    "default.engine_version" = "5.7.mysql_aurora.2.09.2"
    "default.instance_class" = "db.t3.small"
    "default.instance_count" = 1
  }
}

variable "rds_local_writer_domain_name" {
  type    = string
  default = "rds-writer"
}

variable "rds_local_reader_domain_name" {
  type    = string
  default = "rds-reader"
}

variable "vpc" {
  type = map(string)

  default = {}
}
