variable "environment" {
  default = "staging"
}

variable "cidr_block" {
  default = "10.20.0.0/16"
}

variable "subnet_public" {
  default = ["10.20.1.0/24", "10.20.2.0/24"]
}

variable "subnet_private" {
  default = ["10.20.11.0/24", "10.20.12.0/24"]
}

variable "db_allocated_storage" {
  default = 50
}

variable "db_name" {
  default = "stagingdb"
}

variable "db_username" {
  default = "stageadmin"
}

variable "db_password" {
  default = "StagePass123!"
}
