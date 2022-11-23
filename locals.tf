locals {
  applications = concat(local.default_apps, var.argoCDApplications)
  deployCilium = var.kindCluster.config.disableDefaultCNI
  projects     = concat(local.default_projects, var.argoCDProjects)

  default_apps = var.argoCDApps.deploy_default_apps ? [{
    name      = "labtop-info"
    namespace = "argo-cd"
    project   = "labtop"

    destination = {
      namespace = var.argoCD.namespace
      name      = "in-cluster"
    }

    source = {
      chart          = "labtop-info"
      repoURL        = "https://martijnvdp.github.io/helm-repo/"
      targetRevision = "0.0.1"
      helm = {
        values = <<EOF
ingress:
  enabled: ${var.kindCluster.config.ingress}
EOF
      }
    }
    syncPolicy = {

      automated = {
        prune    = true
        selfHeal = true
      }
      syncOptions = ["CreateNamespace=true"]
    }
    }, {
    name      = "game-2048"
    namespace = "argo-cd"
    project   = "labtop"

    destination = {
      namespace = "game-2048"
      name      = "in-cluster"
    }

    source = {
      chart          = "game2048"
      repoURL        = "https://martijnvdp.github.io/helm-repo/"
      targetRevision = "0.1.0"

      helm = {
        values = <<EOF
fullNameOverride: game-2048
replicaCount: 2
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  host: game-2048.127.0.0.1.nip.io
EOF
      }
    }
    syncPolicy = {

      automated = {
        prune    = true
        selfHeal = true
      }
      syncOptions = ["CreateNamespace=true"]
    }
  }] : []

  default_projects = var.argoCDApps.deploy_default_projects ? [{
    name        = "labtop"
    namespace   = "argo-cd"
    description = "laBtop Project"
    sourceRepos = ["'*'"]

    clusterResourceWhitelist = [{
      kind  = "'*'"
      group = "'*'"
    }]

    destinations = [{
      namespace = "'*'"
      name      = "in-cluster"
      server    = "https://kubernetes.default.svc"
    }]
  }] : []

  ArgoCDRepositories = {
    example = {
      name    = "argocd-example-apps"
      project = "labtop"
      url     = "https://github.com/argoproj/argocd-example-apps.git"
      type    = "git"
    },
    labtop = {
      name    = "labtop-info"
      project = "labtop"
      url     = "https://martijnvdp.github.io/helm-repo/"
      type    = "helm"
    }
  }
}
