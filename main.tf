resource "oci_identity_compartment" "free_compartment" {
  compartment_id = var.tenancy
  description    = "Oracle Cloud Free Tier compartment"
  name           = var.prefix
  # enable_delete  = true
}

# resource "oci_core_instance" "free_instance" {
#   availability_domain = data.oci_identity_availability_domains.ads.availability_domains[2].name
#   compartment_id      = oci_identity_compartment.free_compartment.id
#   shape               = var.instance_shape
#   display_name        = "${var.prefix}Instance"

#   shape_config {
#     memory_in_gbs = var.instance_memory
#     ocpus         = var.instance_ocpus
#   }

#   source_details {
#     source_id               = data.oci_core_images.instance_images.images[0].id
#     source_type             = "image"
#     boot_volume_size_in_gbs = var.instance_boot_volume_size
#   }

#   create_vnic_details {
#     assign_public_ip = true
#     subnet_id        = oci_core_subnet.free_subnet.id
#     display_name     = var.instance_hostname
#   }

#   metadata = {
#     ssh_authorized_keys = (var.instance_public_key_path != "") ? file(var.instance_public_key_path) : tls_private_key.instance_ssh_key[0].public_key_openssh
#   }
# }
