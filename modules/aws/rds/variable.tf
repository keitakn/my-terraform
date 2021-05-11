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

variable "bastion" {
  type = map(string)

  default = {
    "default.name"          = "prod-bastion"
    "stg.name"              = "stg-bastion"
    "dev.name"              = "dev-bastion"
    "default.ami"           = "ami-0ca38c7440de1749a"
    "default.instance_type" = "t2.micro"
    "default.volume_type"   = "gp2"
    "default.volume_size"   = "30"
  }
}

variable "vpc" {
  type = map(string)

  default = {}
}
