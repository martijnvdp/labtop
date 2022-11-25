resource "helm_release" "argo_cd" {
  provider         = helm
  name             = var.argoCD.name
  chart            = var.argoCD.chart
  create_namespace = true
  namespace        = var.argoCD.namespace
  repository       = var.argoCD.repository
  timeout          = var.argoCD.timeout
  version          = startswith(var.kindCluster.version, "v1.21") || startswith(var.kindCluster.version, "v1.1") ? "v5.7.0" : var.argoCD.version

  values = [templatefile("${path.module}/templates/argoCD_config.tpl", {
    ingress      = var.kindCluster.config.ingress
    repositories = replace(yamlencode(merge(local.argoCDRepositories, var.argoCDRepositories)), "\"", "")
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
    helm_release.argo_cd,
    kubernetes_manifest.datadogNamespace
  ]
}

resource "kubernetes_secret" "argoCDRepositoryCredentialTemplates" {
  for_each = nonsensitive(toset(keys(var.argoCDRepositoryCredentialTemplates)))
  metadata {
    name      = each.key
    namespace = var.argoCD.namespace
    labels = {
      "argocd.argoproj.io/secret-type" = "repo-creds"
    }
  }

  data = {
    "username" = var.argoCDRepositoryCredentialTemplates[each.key].username
    "password" = var.argoCDRepositoryCredentialTemplates[each.key].password
    "url"      = var.argoCDRepositoryCredentialTemplates[each.key].url
  }

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}
