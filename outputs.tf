# Outputs for compartment

output "compartment-name" {
  description = "The name you assign to the compartment during creation. The name must be unique across all compartments in the parent."
  value       = oci_identity_compartment.free_compartment.name
}

output "compartment-id" {
  description = "The OCID of the compartment."
  value       = oci_identity_compartment.free_compartment.id
}

# Outputs for compute instance

output "instance-name" {
  description = "A user-friendly name. Does not have to be unique, and it's changeable."
  value       = oci_core_instance.free_instance.display_name
}

output "instance-region" {
  description = "The region that contains the availability domain the instance is running in."
  value       = oci_core_instance.free_instance.region
}

output "instance-shape" {
  description = "The shape of the instance. The shape determines the number of CPUs and the amount of memory allocated to the instance."
  value       = oci_core_instance.free_instance.shape
}

output "instance-state" {
  description = "The current state of the instance."
  value       = oci_core_instance.free_instance.state
}

output "instance-public-ip" {
  description = "The public IP address of instance VNIC (if enabled)."
  value       = oci_core_instance.free_instance.public_ip
}

output "generated_private_key" {
  value     = (var.instance_public_key_path != "") ? "" : tls_private_key.instance_ssh_key[1].private_key_pem
  sensitive = true
}
