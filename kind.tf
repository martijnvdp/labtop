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

resource "helm_release" "labtopInfo" {
  provider         = helm
  name             = "labtop-info"
  chart            = "labtop-info"
  create_namespace = true
  namespace        = var.argoCD.namespace
  repository       = "${path.module}/charts"

  set {
    name  = "ingress.enabled"
    value = var.kindCluster.config.ingress
  }

  depends_on = [
    kind_cluster.default,
    helm_release.cilium
  ]
}
