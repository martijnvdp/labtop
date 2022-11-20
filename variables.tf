variable "cilium" {
  type = object({
    chart      = optional(string, "cilium")
    name       = optional(string, "cilium")
    namespace  = optional(string, "kube-system")
    repository = optional(string, "https://helm.cilium.io/")
    version    = optional(string, "v1.11.11")
    settings = optional(object({
      kubeProxyReplacement = optional(string, "strict")
      k8sServiceHost       = optional(string, "labtop-control-plane")
      k8sServicePort       = optional(number, 6443)
      ipamMode             = optional(string, "kubernetes")
      externalIPs = optional(object({
        enabled = optional(bool, true)
      }), {})
      hostPort = optional(object({
        enabled = optional(bool, true)
      }), {})
      hostServices = optional(object({
        enabled = optional(bool, false)
      }), {})
      hubble = optional(object({
        enabled = optional(bool, true)
        relay = optional(object({
          enabled = optional(bool, true)
        }), {})
        ui = optional(object({
          enabled = optional(bool, true)
          ingress = optional(object({
            enabled     = optional(bool, true)
            annotations = optional(map(string), { "kubernetes.io/ingress.class" = "nginx" })
            hosts       = optional(list(string), ["hubble-ui.127.0.0.1.nip.io"])
          }), {})
        }), {})
      }), {})
      nodePort = optional(object({
        enabled = optional(bool, true)
      }), {})
    }), {})
  })
  description = "Cilium settings"
  default     = {}
}

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
