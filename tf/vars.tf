# Variables (equivalent to Heat parameters)
variable "instance_name" {
  type        = string
  description = "Name of the instance (not the stack)"
}

variable "flavor_name" {
  type        = string
  description = "Flavor type of instance. This is ephemeral disk (not persisted)."
}

variable "key" {
  type        = string
  description = "Name of the SSH key to access the instance"
}

variable "image_name" {
  type        = string
  description = "Name of the image"
}

variable "net_id" {
  type        = string
  description = "Id of the network"
}

variable "volume_name" {
  type        = string
  description = "Name of the volume"
}

variable "volume_size" {
  type        = number
  description = "Size in GB of the volume"
}

variable "var_prefix" {
  type = string
  description = "Variable prefix"
  default = "2025-nguen-tf"
}