terraform {
  backend "s3" {
    bucket         = "opg.terraform.state"
    key            = "opg-metrics/terraform.tfstate"
    encrypt        = true
    region         = "eu-west-1"
    role_arn       = "arn:aws:iam::311462405659:role/opg-metrics-ci"
    dynamodb_table = "remote_lock"
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.0"
    }
  }
  required_version = "= 0.14.2"
}

variable "default_role" {
  default = "opg-metrics-ci"
}

provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn     = "arn:aws:iam::679638075911:role/${var.default_role}"
    session_name = "terraform-session"
  }
}

data "aws_region" "current" {}
