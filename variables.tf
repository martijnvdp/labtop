variable "applications" {
  type = object({
    cert-manager       = optional(bool, false)
    externalSecrets    = optional(bool, true)
    game2048           = optional(bool, true)
    gatekeeper         = optional(bool, true)
    grafana            = optional(bool, false)
    kube-state-metrics = optional(bool, false)
    labtop-info        = optional(bool, true)
    prometheus         = optional(bool, false)
  })
  description = "Selection of charts to install in ArgoCD"
  default     = {}
}

variable "argoCD" {
  type = object({
    chart      = optional(string, "argo-cd")
    name       = optional(string, "argo-cd")
    namespace  = optional(string, "argo-cd")
    repository = optional(string, "https://argoproj.github.io/argo-helm")
    timeout    = optional(number, 600)
    version    = optional(string, "v5.14.1")
  })
  description = "ArgoCD deployment settings"
  default     = {}
}

variable "argoCDApps" {
  type = object({
    chart                   = optional(string, "argocd-apps")
    deploy_default_projects = optional(bool, true)
    name                    = optional(string, "argocd-apps")
    namespace               = optional(string, "argo-cd")
    repository              = optional(string, "https://argoproj.github.io/argo-helm")
    version                 = optional(string, "v0.0.3")
  })
  description = "ArgoCD application(sets) and projects helm chart settings"
  default     = {}
}

variable "argoCDApplications" {
  type = list(object({
    name      = string
    namespace = optional(string, "argo-cd")
    project   = optional(string, "labtop")
    destination = object({
      namespace = string
      name      = optional(string, "in-cluster")
    })
    source = object({
      chart          = optional(string, null)
      path           = optional(string, null)
      repoURL        = optional(string, null)
      targetRevision = optional(string, null)
      helm = optional(object({
        values = optional(string, null)
      }), null)
    })
    syncPolicy = optional(object({
      automated = optional(object({
        prune    = optional(bool, true)
        selfHeal = optional(bool, true)
      }), {})
      syncOptions = optional(list(string), ["CreateNamespace=true"])
    }), {})
  }))
  description = "ArgoCD Applications"
  default     = []
}

variable "argoCDProjects" {
  type = list(object({
    name        = string
    namespace   = optional(string, "argo-cd")
    project     = optional(string, "labtop")
    sourceRepos = optional(list(string), ["'*'"])
    clusterResourceWhitelist = optional(list(object({
      kind  = optional(list(string), ["'*'"])
      group = optional(list(string), ["'*'"])
    })), [{}])
    destinations = optional(list(object({
      namespace = optional(list(string), ["'*'"])
      name      = optional(string, "in-cluster")
      server    = optional(string, "https://kubernetes.default.svc")
    })), [{}])
  }))
  description = "ArgoCD Projects"
  default     = []
}

variable "datadog" {
  type = object({
    namespace = optional(string, "datadog")
    secret    = optional(string, "datadog-keys")
    site      = optional(string, "datadoghq.eu")
    version   = optional(string, "datadog")
  })
  description = "Datadog agent deployment settings"
  default     = {}
}

variable "datadogKeys" {
  type = object({
    api = string
    app = string
  })
  description = "Datadog keys"
  sensitive   = true
  default     = null
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

variable "argoCDRepositories" {
  type = map(object({
    url     = string
    name    = string
    project = optional(string, "labtop")
    type    = string
  }))
  description = "Repositories to add to ArgoCD."
  default     = {}
}

variable "argoCDRepositoryCredentialTemplates" {
  type = map(object({
    username = string
    password = string
    url      = string
  }))
  description = "Repository credential templates"
  default     = {}
  sensitive   = true
}
