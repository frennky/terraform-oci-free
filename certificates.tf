resource "oci_kms_key" "free_rsa_key" {
  compartment_id      = oci_identity_compartment.free_compartment.id
  management_endpoint = oci_kms_vault.free_vault.management_endpoint
  display_name        = "${var.prefix}RSAKey"

  key_shape {
    algorithm = "RSA"
    length    = 512
  }

  freeform_tags = local.default_tags
}

resource "oci_identity_dynamic_group" "ca_dg" {
  compartment_id = var.tenancy # created at tenancy level
  name           = "CAs"
  description    = "Dynamic group for all CAs."
  matching_rule  = "All {resource.type = 'certificateauthority'}"

  freeform_tags = local.default_tags
}

resource "oci_identity_policy" "ca_policy" {
  compartment_id = oci_identity_compartment.free_compartment.id
  name           = "${var.prefix}CAPolicy"
  description    = "Allow CAs to use RSA key and manage objects."

  statements = [
    "Allow dynamic-group ${oci_identity_dynamic_group.ca_dg.name} to use keys in compartment ${oci_identity_compartment.free_compartment.name} where target.key.id='${oci_kms_key.free_rsa_key.id}'",
    "Allow dynamic-group ${oci_identity_dynamic_group.ca_dg.name} to manage objects in compartment ${oci_identity_compartment.free_compartment.name}"
  ]

  freeform_tags = local.default_tags
}

resource "oci_certificates_management_certificate_authority" "free_ca" {
  compartment_id = oci_identity_compartment.free_compartment.id
  kms_key_id     = oci_kms_key.free_rsa_key.id
  name           = "${var.prefix}CA"

  certificate_authority_config {
    config_type = "ROOT_CA_GENERATED_INTERNALLY"

    subject {
      common_name = "${var.prefix}_CA"
    }
  }

  freeform_tags = local.default_tags
}

resource "oci_certificates_management_certificate" "free_cert" {
  compartment_id = oci_identity_compartment.free_compartment.id
  name           = "${var.prefix}TLS"
  certificate_config {
    config_type                     = "ISSUED_BY_INTERNAL_CA"
    certificate_profile_type        = "TLS_SERVER_OR_CLIENT"
    issuer_certificate_authority_id = oci_certificates_management_certificate_authority.free_ca.id

    subject {
      common_name = "${var.prefix}_Cert"
    }
  }

  freeform_tags = local.default_tags
}
