variable "tenancy_ocid" {
  description = "The tenancy OCID for a user. The tenancy OCID can be found at the bottom of user settings in the Oracle Cloud Infrastructure console. Required if auth is set to 'ApiKey', ignored otherwise."
  type        = string
}

variable "user_ocid" {
  description = "The user OCID. This can be found in user settings in the Oracle Cloud Infrastructure console. Required if auth is set to 'ApiKey', ignored otherwise."
  type        = string
}

variable "private_key_path" {
  description = "The path to the user's PEM formatted private key. A private_key or a private_key_path must be provided if auth is set to 'ApiKey', ignored otherwise."
  type        = string
}

variable "fingerprint" {
  description = "The fingerprint for the user's RSA key. This can be found in user settings in the Oracle Cloud Infrastructure console. Required if auth is set to 'ApiKey', ignored otherwise."
  type        = string
}

variable "region" {
  description = "The region for API connections (e.g. us-ashburn-1)."
  type        = string
}

variable "image_operating_system" {
  description = "The image's operating system."
  type        = string
  default     = "Canonical Ubuntu"
}

variable "image_operating_system_version" {
  description = "The image's operating system version."
  type        = string
  default     = "22.04"
}

variable "instance_hostname" {
  description = "A user-friendly name. Does not have to be unique, and it's changeable. Avoid entering confidential information."
  type        = string
  default     = "freetierinstance"
}

variable "instance_shape" {
  description = "The shape of an instance. The shape determines the number of CPUs, amount of memory, and other resources allocated to the instance."
  type        = string
  default     = "VM.Standard.A1.Flex"
}

variable "instance_ocpus" {
  description = "The total number of OCPUs available to the instance."
  type        = number
  default     = 4
}

variable "instance_memory" {
  description = "The total amount of memory available to the instance, in gigabytes."
  type        = number
  default     = 24
}

variable "instance_boot_volume_size" {
  description = "The size of the boot volume in GBs. Minimum value is 50 GB and maximum value is 32,768 GB (32 TB)."
  type        = number
  default     = 200
}

variable "instance_public_key_path" {
  description = "Public SSH key to be included in the ~/.ssh/authorized_keys file for the default user on the instance."
  type        = string
  default     = "~/.ssh/oci.pub"
}
