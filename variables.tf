variable "workspace" {
  type = object({
    name    = string
    project = string
    region  = string
  })
  description = "The workspace that will be created on GCP. Requires the **name** of the build (e.g \"bounce\"), the ID of a GCP **project** and the **region** of deployment on GCP. The **name** attributes must contain only lowercase letters."

  validation {
    condition     = can(regex("^[a-z]*$", var.workspace.name))
    error_message = "The name of the build should be a valid name with only lowercase letters allowed."
  }
}