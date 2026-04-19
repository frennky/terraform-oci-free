# Docs https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/identity_availability_domains

# <tenancy-ocid> is the compartment OCID for the root compartment.
# Use <tenancy-ocid> for the compartment OCID.

data "oci_identity_availability_domains" "ads" {
  compartment_id = var.tenancy_ocid
}

# Docs https://registry.terraform.io/providers/oracle/oci/latest/docs/data-sources/core_images

# <tenancy-ocid> is the compartment OCID for the root compartment.
# Use <tenancy-ocid> for the compartment OCID.

data "oci_core_images" "instance_images" {
  compartment_id           = var.tenancy_ocid
  operating_system         = var.image_operating_system
  operating_system_version = var.image_operating_system_version
  shape                    = var.instance_shape
}
