terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.17.0"
    }
  }
  required_version = ">= 1.1.0"
  # use cloud stored state
  cloud {
    organization = "Demo"

    workspaces {
      name = "infra-demo"
    }
  }
}

provider "aws" {
  region = var.aws_region
}
