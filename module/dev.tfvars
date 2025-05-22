variable "environment" {
  default = "dev"
}

variable "cidr_block" {
  default = "10.10.0.0/16"
}

variable "subnet_public" {
  default = ["10.10.1.0/24", "10.10.2.0/24"]
}

variable "subnet_private" {
  default = ["10.10.11.0/24", "10.10.12.0/24"]
}

variable "db_allocated_storage" {
  default = 20
}

variable "db_name" {
  default = "devdb"
}

variable "db_username" {
  default = "devadmin"
}

variable "db_password" {
  default = "DevPass123!"
}
