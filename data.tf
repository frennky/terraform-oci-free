data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy
}

data "oci_core_images" "instance_images" {
  compartment_id           = var.tenancy
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.instance_shape
}

data "oci_secrets_secretbundle" "free_instance_private_key" {
  secret_id = oci_vault_secret.free_instance_private_key.id
  stage     = "CURRENT"
}

data "oci_secrets_secretbundle" "free_instance_public_key" {
  secret_id = oci_vault_secret.free_instance_public_key.id
  stage     = "CURRENT"
}
