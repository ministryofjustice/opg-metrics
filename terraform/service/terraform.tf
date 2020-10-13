terraform {
  backend "s3" {
    bucket         = "opg.terraform.state"
    key            = "opg-aws-sandbox/opg-metrics/terraform.tfstate"
    encrypt        = true
    region         = "eu-west-1"
    role_arn       = "arn:aws:iam::311462405659:role/sandbox-ci"
    dynamodb_table = "remote_lock"
  }
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
  required_version = ">= 0.13.2"
}

variable "default_role" {
  type    = string
  default = "sandbox-ci"
}

variable "management_role" {
  default = "sandbox-ci"
}

provider "aws" {
  region = "eu-west-1"

  assume_role {
    role_arn     = "arn:aws:iam::995199299616:role/${var.default_role}"
    session_name = "terraform-session"
  }
}

provider "aws" {
  alias  = "management"
  region = "eu-west-1"

  assume_role {
    role_arn     = "arn:aws:iam::311462405659:role/${var.management_role}"
    session_name = "terraform-session"
  }
}
