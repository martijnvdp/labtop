variable "argoCD" {
  type = object({
    chart      = optional(string, "argo-cd")
    name       = optional(string, "argo-cd")
    namespace  = optional(string, "argo-cd")
    repository = optional(string, "https://argoproj.github.io/argo-helm")
    timeout    = optional(number, 600)
    version    = optional(string, "v5.7.0") # higher version requires k8 1.22+
  })
  description = "ArgoCD deployment settings"
  default     = {}
}

variable "argoCDApps" {
  type = object({
    chart                   = optional(string, "argocd-apps")
    name                    = optional(string, "argocd-apps")
    namespace               = optional(string, "argo-cd")
    repository              = optional(string, "https://argoproj.github.io/argo-helm")
    version                 = optional(string, "v0.0.3")
    deploy_default_apps     = optional(bool, true)
    deploy_default_projects = optional(bool, true)
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

variable "ArgoCDRepositories" {
  type = map(object({
    url     = string
    name    = string
    project = optional(string, "labtop")
    type    = string
  }))
  description = "Repositories to add to ArgoCD."
  default     = {}
}

variable "ArgoCDRepositoryCredentialTemplates" {
  type = map(object({
    username = string
    password = string
    url      = string
  }))
  description = "Repository credential templates"
  default     = {}
  sensitive   = true
}
