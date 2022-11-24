locals {
  applications  = concat(local.defaultCharts, var.argoCDApplications)
  deployCilium  = var.kindCluster.config.disableDefaultCNI
  deployDatadog = var.datadog != null
  projects      = concat(local.default_projects, var.argoCDProjects)

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
