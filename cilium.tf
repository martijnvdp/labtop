resource "helm_release" "cilium" {
  count = local.deployCilium ? 1 : 0

  provider   = helm
  name       = var.cilium.name
  chart      = var.cilium.chart
  namespace  = var.cilium.namespace
  repository = var.cilium.repository
  version    = var.cilium.version

  values = [yamlencode(var.cilium.settings)]

  depends_on = [
    kind_cluster.default
  ]
}
