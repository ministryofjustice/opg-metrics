resource "aws_vpc" "main" {
  cidr_block           = var.cidr
  instance_tenancy     = var.instance_tenancy
  enable_dns_hostnames = var.enable_dns_hostnames
  enable_dns_support   = var.enable_dns_support
  tags = merge(
    var.tags,
    { name = "${local.name-prefix}-vpc" },
  )
}

resource "aws_vpc_dhcp_options" "dns_resolver" {
  domain_name         = var.dhcp_options_domain_name
  domain_name_servers = var.dhcp_options_domain_name_servers
  tags = merge(
    var.tags,
    { name = "${local.name-prefix}-dns-resolver" },
  )
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = merge(
    var.tags,
    { name = "${local.name-prefix}-internet-gateway" },
  )
}

resource "aws_eip" "nat" {
  count = 3
  vpc   = true

  tags = merge(
    var.tags,
    { name = "${local.name-prefix}-eip-nat-gateway" },
  )
}

resource "aws_nat_gateway" "gw" {
  count         = 3
  allocation_id = aws_eip.nat[count.index].id
  subnet_id     = aws_subnet.public[count.index].id

  tags = merge(
    var.tags,
    { name = "${local.name-prefix}-nat-gateway-${data.aws_availability_zones.all.names[count.index]}" },
  )
}
