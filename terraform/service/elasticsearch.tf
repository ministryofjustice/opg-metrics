variable "domain" {
  default = "metrics-1"
  type    = string
}

resource "aws_security_group" "elasticsearch" {
  name        = "elasticsearch-${var.domain}"
  description = "Managed by Terraform"
  vpc_id      = data.aws_vpc.vpc.id
}

resource "aws_security_group_rule" "elasticsearch_vpc_http_ingress" {
  type              = "ingress"
  from_port         = 80
  to_port           = 80
  protocol          = "tcp"
  security_group_id = aws_security_group.elasticsearch.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_security_group_rule" "elasticsearch_vpc_https_ingress" {
  type              = "ingress"
  from_port         = 443
  to_port           = 443
  protocol          = "tcp"
  security_group_id = aws_security_group.elasticsearch.id
  cidr_blocks       = [data.aws_vpc.vpc.cidr_block]
}

resource "aws_elasticsearch_domain" "test_cluster" {
  domain_name           = var.domain
  elasticsearch_version = "7.7"

  cluster_config {
    instance_count         = 3
    instance_type          = "m4.large.elasticsearch"
    zone_awareness_enabled = true
    zone_awareness_config {
      availability_zone_count = 3
    }
  }

  encrypt_at_rest {
    enabled = true
  }

  node_to_node_encryption {
    enabled = true
  }

  vpc_options {
    subnet_ids = data.aws_subnet_ids.data.ids

    security_group_ids = [aws_security_group.elasticsearch.id]
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  snapshot_options {
    automated_snapshot_start_hour = 23
  }

  ebs_options {
    ebs_enabled = true
    volume_size = 10
  }

  tags = {
    Domain = "TestDomain"
  }
}

resource "aws_elasticsearch_domain_policy" "elasticsearch_client_access" {
  domain_name     = aws_elasticsearch_domain.test_cluster.domain_name
  access_policies = data.aws_iam_policy_document.elasticsearch_client.json
}

data "aws_iam_policy_document" "elasticsearch_client" {
  statement {
    actions = [
      "es:*",
    ]

    resources = [
      "${aws_elasticsearch_domain.test_cluster.arn}",
      "${aws_elasticsearch_domain.test_cluster.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}
