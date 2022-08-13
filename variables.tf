variable "project" {
  type        = string
  description = "The GCP **project** that will be used to create the packer build infra."
}

variable "region" {
  type        = string
  description = "The GCP **region** that will be used to create the packer build network."
}

variable "name" {
  type        = string
  description = "The **name** of the packer build that will be used for reference. Only lowercase letters are allowed."

  validation {
    condition     = can(regex("^[a-z]*$", var.name))
    error_message = "The packer build name should be a valid name with only lowercase letters allowed."
  }
}