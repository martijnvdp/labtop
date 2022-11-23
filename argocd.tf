resource "helm_release" "argo_cd" {
  provider         = helm
  name             = var.argoCD.name
  chart            = var.argoCD.chart
  create_namespace = true
  namespace        = var.argoCD.namespace
  repository       = var.argoCD.repository
  timeout          = var.argoCD.timeout
  version          = var.argoCD.version

  values = [templatefile("${path.module}/templates/argoCD_config.tpl", {
    ingress      = var.kindCluster.config.ingress
    repositories = replace(yamlencode(merge(local.ArgoCDRepositories, var.ArgoCDRepositories)), "\"", "")
  })]

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}

resource "helm_release" "argo_cd_apps" {
  provider         = helm
  name             = var.argoCDApps.name
  chart            = var.argoCDApps.chart
  create_namespace = true
  namespace        = var.argoCDApps.namespace
  repository       = var.argoCDApps.repository
  version          = var.argoCDApps.version

  values = compact([templatefile("${path.module}/templates/argoCD_apps.tpl.yaml", {
    applications = replace(yamlencode(local.applications), "\"", "")
    projects     = replace(yamlencode(local.projects), "\"", "")
  })])

  depends_on = [
    kind_cluster.default,
    helm_release.argo_cd
  ]
}

resource "kubernetes_secret" "ArgoCDRepositoryCredentialTemplates" {
  for_each = nonsensitive(toset(keys(var.ArgoCDRepositoryCredentialTemplates)))
  metadata {
    name      = each.key
    namespace = var.argoCD.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    "username" = var.ArgoCDRepositoryCredentialTemplates[each.key].username
    "password" = var.ArgoCDRepositoryCredentialTemplates[each.key].password
    "url"      = var.ArgoCDRepositoryCredentialTemplates[each.key].url
  }

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}
