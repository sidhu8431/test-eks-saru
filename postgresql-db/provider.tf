terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.92.0"
    }
  }

}


provider "aws" {
  # Configuration optionsS
  region = "us-east-2"
}