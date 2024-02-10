terraform {
  required_version = ">= 1.7.0"

  required_providers {
    oci = {
      source  = "oracle/oci"
      version = ">= 5.26.0"
    }

    local = {
      source  = "hashicorp/local"
      version = "2.4.1"
    }

    tls = {
      source  = "hashicorp/tls"
      version = "4.0.5"
    }
  }

  backend "s3" {
    bucket                      = "tfstate"
    key                         = "free/terraform.tfstate"
    shared_config_files         = ["~/.oci/config"] # TODO: pathexpand?
    shared_credentials_files    = ["~/.oci/credentials"]
    skip_region_validation      = true
    skip_credentials_validation = true
    skip_requesting_account_id  = true
    use_path_style              = true
    skip_metadata_api_check     = true
    skip_s3_checksum            = true
  }
}

provider "oci" {
  user_ocid        = var.user
  fingerprint      = var.fingerprint
  tenancy_ocid     = var.tenancy
  region           = var.region
  private_key_path = var.key_file
}
