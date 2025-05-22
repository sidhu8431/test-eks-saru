
variable "environment" {
  type        = string
  default     = "qa"
  description = "Environment for the deployment (e.g., dev, staging, prod)."
}


variable "db_instance_class" {
  description = "The instance class to use"
  type        = string
  default     = "db.t3.medium"
}




variable "instance_type" {
  default = "t2.micro"
}

variable "cluster_name" {
  default = "logistics-cluster"
}
variable "cluster_version" {
  default = "1.31"
}
variable "node_groups" {
 
  description = "EKS node group configuration"
  type = map(object({
    instance_types = list(string)
    node_group_name = string
    capacity_type  = string
    scaling_config = object({
      desired_size = number
      max_size     = number
      min_size     = number
    })
  }))
  default = {
    general = {
      instance_types = ["t2.medium"]
      capacity_type  = "SPOT"
      node_group_name = "logistics-node"
      scaling_config = {
        desired_size = 2
        max_size     = 4
        min_size     = 2
      }
    }
  }
}

