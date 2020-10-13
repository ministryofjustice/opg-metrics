data "aws_region" "current" {}

data "aws_caller_identity" "current" {}

data "aws_vpc" "vpc" {
  id = "vpc-00b06ba660234f132"
}

data "aws_subnet_ids" "data" {
  vpc_id = data.aws_vpc.vpc.id

  filter {
    name   = "tag:Name"
    values = ["data-*"]
  }
}
