locals {
  helm_apps = [{
    name = "cert-manager"

    destination = {
      namespace = "cert-manager"
    }

    source = {
      chart          = "cert-manager"
      repoURL        = "https://charts.jetstack.io"
      targetRevision = "1.10.1"

      helm = {
        values = <<EOF
fullNameOverride: cert-manager
installCRDs: true
EOF
      }
    }
    }, {
    name = "grafana"

    destination = {
      namespace = "grafana"
    }

    source = {
      chart          = "grafana"
      repoURL        = "https://grafana.github.io/helm-charts"
      targetRevision = "6.44.8"

      helm = {
        values = <<EOF
sidecar:
  dashboards:
    enabled: true
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  hosts:
  - grafana.127.0.0.1.nip.io
EOF
    } } }, {
    name = "grafana-dashboards"
    destination = {
      namespace = "grafana"
    }

    source = {
      path           = "./"
      repoURL        = "https://github.com/dotdc/grafana-dashboards-kubernetes"
      targetRevision = "HEAD"
    }
  }]
}

module "eks" {
  source = "../../"

  argoCDApplications = local.helm_apps

  kindCluster = {
    config = {
      controlNodes = 1
      workerNodes  = 2
    }
  }
}
