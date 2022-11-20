resource "kind_cluster" "default" {
  name       = var.kindCluster.name
  node_image = "kindest/node:${var.kindCluster.version}"

  kind_config = templatefile("${path.module}/templates/kind_config.tpl", {
    controlNodes      = var.kindCluster.config.controlNodes
    disableDefaultCNI = var.kindCluster.config.disableDefaultCNI
    workerNodes       = var.kindCluster.config.workerNodes
  })
}
