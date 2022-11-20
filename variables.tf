variable "kindCluster" {
  type = object({
    name    = optional(string, "lab")
    version = optional(string, "v1.22.15")
    config = optional(object({
      controlNodes      = optional(number, 1)
      disableDefaultCNI = optional(bool, true)
      ingress           = optional(bool, true)
      workerNodes       = optional(number, 3)
    }), {})
  })
  description = "Cluster settings"
  default     = {}
}
