resource "oci_kms_vault" "free_vault" {
  compartment_id = oci_identity_compartment.free_compartment.id
  display_name   = "${var.prefix}Vault"
  vault_type     = "DEFAULT"
}

resource "oci_kms_key" "free_aes_key" {
  compartment_id      = oci_identity_compartment.free_compartment.id
  management_endpoint = oci_kms_vault.free_vault.management_endpoint
  display_name        = "${var.prefix}AESKey"

  key_shape {
    algorithm = "AES"
    length    = 32
  }
}

resource "tls_private_key" "free_instance_keypair" {
  count     = (var.instance_public_key_path == "") ? 1 : 0
  algorithm = "ED25519"
}

resource "oci_vault_secret" "free_instance_private_key" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vault_id       = oci_kms_vault.free_vault.id
  key_id         = oci_kms_key.free_aes_key.id
  secret_name    = "free_instance_private_key"

  secret_content {
    content_type = "BASE64"
    content      = base64encode(tls_private_key.free_instance_keypair[0].private_key_openssh)
    name         = "free_instance_private_key"
    stage        = "CURRENT"
  }

}

resource "oci_vault_secret" "free_instance_public_key" {
  compartment_id = oci_identity_compartment.free_compartment.id
  vault_id       = oci_kms_vault.free_vault.id
  key_id         = oci_kms_key.free_aes_key.id
  secret_name    = "free_instance_public_key"

  secret_content {
    content_type = "BASE64"
    content      = base64encode(tls_private_key.free_instance_keypair[0].public_key_openssh)
    name         = "free_instance_public_key"
    stage        = "CURRENT"
  }
}

resource "local_sensitive_file" "free_instance_private_key" {
  count           = (var.instance_public_key_path == "") ? 1 : 0
  content         = base64decode(data.oci_secrets_secretbundle.free_instance_private_key.secret_bundle_content[0].content)
  filename        = pathexpand("~/.ssh/oci_ED25519")
  file_permission = "0600"
}

resource "local_file" "instance_public_key" {
  count           = (var.instance_public_key_path == "") ? 1 : 0
  content         = base64decode(data.oci_secrets_secretbundle.free_instance_public_key.secret_bundle_content[0].content)
  filename        = pathexpand("~/.ssh/oci_ED25519.pub")
  file_permission = "0644"
}
