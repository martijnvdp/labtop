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
    ingress = var.kindCluster.config.ingress
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
