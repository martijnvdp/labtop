resource "helm_release" "cilium" {
  count = local.deployCilium ? 1 : 0

  provider   = helm
  chart      = var.cilium.chart
  name       = var.cilium.name
  namespace  = var.cilium.namespace
  repository = var.cilium.repository
  version    = var.cilium.version

  values = [templatefile("${path.module}/templates/cilium_config.tpl", {
    ingress = var.kindCluster.config.ingress
  })]

  depends_on = [
    kind_cluster.default
  ]
}
