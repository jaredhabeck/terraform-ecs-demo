# variables
variable "tags" {
  type = map(any)
  default = {
    Department  = "Software"
    Application = "Demo"
    ManagedBy   = "Terraform"
  }
}

variable "aws_region" {
  type    = string
  default = "us-east-2"
}

variable "app_name" {
  type    = string
  default = "demo"
}

variable "ssh_key_name" {
  type    = string
  default = "ssh_key"
}

# TODO this can be gathered most likely via a call to kms
variable "ssl_certificate_arn" {
  type    = string
  default = "arn:aws:acm:us-east-2:<account_id>:certificate/<cert_arn>"
}

variable "ecs_ec2_ami" {
  type    = string
  default = "ami-00000000000000000"
}

variable "cidr_block" {
  type    = string
  default = "10.1.0.0/16"
}

/* For use at multi-az transition
variable "public_subnet_cidrs" {
  type = map(string)
  default = [
    "10.0.1.0/20",
    "10.0.2.0/20",
  ]
}

variable "private_subnet_cidrs" {
  type = map(string)
  default = [
    "10.0.3.0/20",
    "10.0.4.0/20",
  ]
}

variable "availability_zones" {
  type = list(string)
  default = [
    "us-east-2a",
    "us-east-2b"
  ]
}
*/

variable "redis_port" {
  type    = string
  default = 6379
}

variable "ecs_ec2_instance_type" {
  type    = string
  default = "t3.medium"
}

variable "rds_instance_class" {
  type    = string
  default = "db.t3.micro"
}

data "aws_caller_identity" "current" {}

output "account_id" {
  value = data.aws_caller_identity.current.account_id
}

data "aws_ssm_parameter" "APP_ENV" {
  name = "APP_ENV"
}

data "aws_ssm_parameter" "WORKER_APP_ENV" {
  name = "WORKER_APP_ENV"
}
