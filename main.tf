terraform {
  required_version = ">= 1.3.7"

  required_providers {
    oci = {
      version = ">= 4.104.0"
    }
    tls = {
      source  = "hashicorp/tls"
      version = "4.0.4"
    }
  }

  backend "s3" {
    bucket                      = "tfstate"
    key                         = "free/terraform.tfstate"
    shared_credentials_file     = "credentials"
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_metadata_api_check     = true
    force_path_style            = true
  }
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs

provider "oci" {
  user_ocid        = var.user
  fingerprint      = var.fingerprint
  tenancy_ocid     = var.tenancy
  region           = var.region
  private_key_path = var.key_file
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/identity_compartment

resource "oci_identity_compartment" "free_compartment" {
  compartment_id = var.tenancy
  description    = "Oracle Cloud Free Tier compartment"
  name           = "free"
  enable_delete  = true
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_vcn

resource "oci_core_vcn" "free_vcn" {
  cidr_block     = "10.1.0.0/16"
  compartment_id = oci_identity_compartment.free_compartment.id
  display_name   = "freeVCN"
  dns_label      = "freevcn"
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_subnet

resource "oci_core_subnet" "free_subnet" {
  cidr_block        = "10.1.20.0/24"
  display_name      = "freeSubnet"
  dns_label         = "freesubnet"
  security_list_ids = [oci_core_security_list.free_security_list.id]
  compartment_id    = oci_identity_compartment.free_compartment.id
  vcn_id            = oci_core_vcn.free_vcn.id
  route_table_id    = oci_core_route_table.free_route_table.id
  dhcp_options_id   = oci_core_vcn.free_vcn.default_dhcp_options_id
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_internet_gateway

resource "oci_core_internet_gateway" "free_internet_gateway" {
  compartment_id = oci_identity_compartment.free_compartment.id
  display_name   = "freeIG"
  vcn_id         = oci_core_vcn.free_vcn.id
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_route_table

resource "oci_core_route_table" "free_route_table" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vcn_id         = oci_core_vcn.free_vcn.id
  display_name   = "freeRouteTable"

  route_rules {
    destination       = "0.0.0.0/0"
    destination_type  = "CIDR_BLOCK"
    network_entity_id = oci_core_internet_gateway.free_internet_gateway.id
  }
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_security_list

resource "oci_core_security_list" "free_security_list" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vcn_id         = oci_core_vcn.free_vcn.id
  display_name   = "freeSecurityList"

  egress_security_rules {
    protocol    = "6"
    destination = "0.0.0.0/0"
  }

  ingress_security_rules {
    protocol = "6"
    source   = "0.0.0.0/0"

    tcp_options {
      max = "22"
      min = "22"
    }
  }
}

resource "tls_private_key" "instance_ssh_key" {
  count     = var.instance_public_key_path != "" ? 1 : 0
  algorithm = "ED25519"
}

# https://registry.terraform.io/providers/oracle/oci/latest/docs/resources/core_instance

resource "oci_core_instance" "free_instance" {
  availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
  compartment_id      = oci_identity_compartment.free_compartment.id
  shape               = var.instance_shape
  display_name        = "freeInstance"

  shape_config {
    memory_in_gbs = var.instance_memory
    ocpus         = var.instance_ocpus
  }

  source_details {
    source_id               = data.oci_core_images.instance_images.images[0].id
    source_type             = "image"
    boot_volume_size_in_gbs = var.instance_boot_volume_size
  }

  create_vnic_details {
    assign_public_ip = true
    subnet_id        = oci_core_subnet.free_subnet.id
    display_name     = var.instance_hostname
  }

  metadata = {
    ssh_authorized_keys = (var.instance_public_key_path != "") ? file("${var.instance_public_key_path}") : tls_private_key.instance_ssh_key[1].public_key_openssh
  }
}
