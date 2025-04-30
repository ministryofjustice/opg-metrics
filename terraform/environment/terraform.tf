terraform {
  backend "s3" {
    bucket  = "opg.terraform.state"
    key     = "opg-metrics/terraform.tfstate"
    encrypt = true
    region  = "eu-west-1"
    assume_role = {
      role_arn = "arn:aws:iam::311462405659:role/opg-metrics-state-access"
    }
    use_lockfile = true
  }
}

variable "default_role" {
  default = "opg-metrics-ci"
  type    = string
}

variable "management_role" {
  default = "opg-metrics-ci"
  type    = string
}

provider "aws" {
  region = "eu-west-1"
  assume_role {
    role_arn     = "arn:aws:iam::${local.environment.account_id}:role/${var.default_role}"
    session_name = "opg-metrics-terraform-session"
  }
}

provider "aws" {
  region = "eu-west-1"
  alias  = "management"
  assume_role {
    role_arn     = "arn:aws:iam::311462405659:role/${var.management_role}"
    session_name = "opg-metrics-terraform-session"
  }
}

data "aws_region" "current" {}

data "aws_caller_identity" "current" {
}
