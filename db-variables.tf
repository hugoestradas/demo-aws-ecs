variable "rds_identifier" {
  default = "db"
}

variable "rds_instance_type" {
  default = "db.t3.micro"
}

variable "rds_storage_size" {
  default = "5"
}

variable "rds_engine" {
  default = "postgres"
}

variable "rds_engine_version" {
  default = "14.3"
}

variable "rds_db_name" {
  default = "db_demo"
}

variable "rds_admin_user" {
  default = "demodbadmin"
}

variable "rds_admin_password" {
  default = "DemoDB23133$122"
}

variable "rds_publicly_accessible" {
  default = "false"
}