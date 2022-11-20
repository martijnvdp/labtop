variable "kindCluster" {
  type = object({
    name    = optional(string, "lab")
    version = optional(string, "v1.22.15")
    config = optional(object({
      disableDefaultCNI = optional(bool, true)
      controlNodes      = optional(number, 1)
      workerNodes       = optional(number, 3)
    }), {})
  })
  description = "Cluster settings"
  default     = {}
}
