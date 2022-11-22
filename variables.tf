variable "argoCD" {
  type = object({
    chart      = optional(string, "argo-cd")
    name       = optional(string, "argo-cd")
    namespace  = optional(string, "argo-cd")
    repository = optional(string, "https://argoproj.github.io/argo-helm")
    timeout    = optional(number, 600)
    version    = optional(string, "v5.7.0") # higher version requires k8 1.22+
  })
  description = "ArgoCD controller settings"
  default     = {}
}

variable "cilium" {
  type = object({
    chart      = optional(string, "cilium")
    name       = optional(string, "cilium")
    namespace  = optional(string, "kube-system")
    repository = optional(string, "https://helm.cilium.io/")
    version    = optional(string, "v1.12.4")
  })
  description = "Cilium settings"
  default     = {}
}

variable "ingressController" {
  type = object({
    chart      = optional(string, "ingress-nginx")
    name       = optional(string, "ingress-nginx")
    namespace  = optional(string, "ingress-nginx")
    repository = optional(string, "https://kubernetes.github.io/ingress-nginx")
    values     = optional(string, "")
    version    = optional(string, "v4.4.0")
  })
  description = "Ingress controller settings"
  default     = {}
}

variable "kindCluster" {
  type = object({
    name         = optional(string, "labtop")
    version      = optional(string, "v1.22.15")
    waitForReady = optional(bool, false)
    config = optional(object({
      controlNodes      = optional(number, 1)
      disableDefaultCNI = optional(bool, true)
      ingress           = optional(bool, true)
      workerNodes       = optional(number, 0)
    }), {})
  })
  description = "Cluster settings"
  default     = {}
}
