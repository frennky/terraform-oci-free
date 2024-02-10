resource "oci_core_vcn" "free_vcn" {
  compartment_id = oci_identity_compartment.free_compartment.id
  cidr_blocks    = [var.vcn_cidr]
  display_name   = "${var.prefix}VCN"
  dns_label      = "${var.prefix}vcn"
  is_ipv6enabled = false

  freeform_tags = local.default_tags
}

resource "oci_core_internet_gateway" "free_ig" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vcn_id         = oci_core_vcn.free_vcn.id
  display_name   = "${var.prefix}IneternetGateway"

  freeform_tags = local.default_tags
}

resource "oci_core_route_table" "free_rt" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vcn_id         = oci_core_vcn.free_vcn.id
  display_name   = "${var.prefix}RouteTable"

  route_rules {
    network_entity_id = oci_core_internet_gateway.free_ig.id
    destination_type  = "CIDR_BLOCK"
    destination       = "0.0.0.0/0"
  }

  freeform_tags = local.default_tags
}

resource "oci_core_security_list" "free_sl" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vcn_id         = oci_core_vcn.free_vcn.id
  display_name   = "${var.prefix}SecurityList"

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow SSH from any source."

    tcp_options {
      max = "22"
      min = "22"
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow HTTP from any source."

    tcp_options {
      min = 80
      max = 80
    }
  }

  ingress_security_rules {
    protocol    = "6"
    source      = "0.0.0.0/0"
    description = "Allow HTTPS from any source."

    tcp_options {
      min = 443
      max = 443
    }
  }

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
    description = "Allow TCP to any destination."
  }

  freeform_tags = local.default_tags
}

resource "oci_core_subnet" "free_public_subnet" {
  compartment_id    = oci_identity_compartment.free_compartment.id
  vcn_id            = oci_core_vcn.free_vcn.id
  cidr_block        = local.public_subnet
  display_name      = "${var.prefix}PublicSubnet"
  dns_label         = "publicsubnet"
  route_table_id    = oci_core_route_table.free_rt.id
  security_list_ids = [oci_core_security_list.free_sl.id]

  freeform_tags = local.default_tags
}
