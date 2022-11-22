locals {
  deployCilium = var.kindCluster.config.disableDefaultCNI
}

resource "null_resource" "labtop-info" {
  count = var.kindCluster.config.ingress ? 1 : 0
  provisioner "local-exec" {
    command = "echo LaBTop info: http://labtop-info.127.0.0.1.nip.io/"
  }

  depends_on = [
    kind_cluster.default,
    helm_release.argo_cd,
    helm_release.labtopInfo,
    helm_release.cilium
  ]
}
