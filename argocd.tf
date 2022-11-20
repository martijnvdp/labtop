resource "helm_release" "argo_cd" {
  provider         = helm
  name             = var.argoCD.name
  chart            = var.argoCD.chart
  create_namespace = true
  namespace        = var.argoCD.namespace
  repository       = var.argoCD.repository
  version          = var.argoCD.version

  values = [templatefile("${path.module}/templates/argoCD_config.tpl", {
    ingress = var.kindCluster.config.ingress
  })]

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}
