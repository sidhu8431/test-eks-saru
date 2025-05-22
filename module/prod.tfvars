variable "environment" {
  default = "prod"
}

variable "cidr_block" {
  default = "10.30.0.0/16"
}

variable "subnet_public" {
  default = ["10.30.1.0/24", "10.30.2.0/24"]
}

variable "subnet_private" {
  default = ["10.30.11.0/24", "10.30.12.0/24"]
}

variable "db_allocated_storage" {
  default = 100
}

variable "db_name" {
  default = "proddb"
}

variable "db_username" {
  default = "prodadmin"
}

variable "db_password" {
  default = "ProdPass123!"
}
