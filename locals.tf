locals {
  private_subnet = cidrsubnet(var.vcn_cidr, 8, 0)
  public_subnet  = cidrsubnet(var.vcn_cidr, 8, 1)

  default_tags = {
    Environment = "Dev"
  }
}
