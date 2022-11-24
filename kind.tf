resource "kind_cluster" "default" {
  name           = var.kindCluster.name
  node_image     = "kindest/node:${var.kindCluster.version}"
  wait_for_ready = var.kindCluster.waitForReady

  kind_config {
    kind        = "Cluster"
    api_version = "kind.x-k8s.io/v1alpha4"
    networking {
      disable_default_cni = var.kindCluster.config.disableDefaultCNI
      kube_proxy_mode     = var.kindCluster.config.disableDefaultCNI ? "none" : "iptables"
    }

    dynamic "node" {
      for_each = var.kindCluster.config.ingress ? range(var.kindCluster.config.controlNodes) : range(0)

      content {
        role = "control-plane"

        kubeadm_config_patches = [
          "kind: InitConfiguration\nnodeRegistration:\n  kubeletExtraArgs:\n    node-labels: \"ingress-ready=true\"\n"
        ]

        extra_port_mappings {
          container_port = 80
          host_port      = 80
        }
        extra_port_mappings {
          container_port = 443
          host_port      = 443
        }
      }
    }

    dynamic "node" {
      for_each = !var.kindCluster.config.ingress ? range(var.kindCluster.config.controlNodes) : range(0)

      content {
        role = "control-plane"
      }
    }

    dynamic "node" {
      for_each = range(var.kindCluster.config.workerNodes)

      content {
        role = "worker"
      }
    }
  }
}

resource "null_resource" "labtop-info" {
  count = var.kindCluster.config.ingress ? 1 : 0
  provisioner "local-exec" {
    command = "echo LaBTop info: http://labtop-info.127.0.0.1.nip.io/"
  }

  depends_on = [
    helm_release.argo_cd_apps
  ]
}
