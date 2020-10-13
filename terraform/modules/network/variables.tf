variable "tags" {}

variable "cidr" {
  type    = string
  default = "0.0.0.0/0"
}

variable "instance_tenancy" {
  type    = string
  default = "default"
}

variable "enable_dns_hostnames" {
  type    = bool
  default = true
}

variable "enable_dns_support" {
  type    = bool
  default = true
}

variable "dhcp_options_domain_name" {
  type    = string
  default = ""
}

variable "dhcp_options_domain_name_servers" {
  type    = list(string)
  default = ["AmazonProvidedDNS"]
}

variable "map_public_ip_on_launch" {
  type    = bool
  default = false
}

variable "public_subnet_assign_ipv6_address_on_creation" {
  type    = bool
  default = false
}

variable "default_security_group_name" {
  type    = string
  default = "default"
}

variable "default_security_group_ingress" {
  type    = list(map(string))
  default = null
}

variable "default_security_group_egress" {
  type    = list(map(string))
  default = null
}
