module "eks" {
  source = "../../"

  helmCharts = {
    grafana = {
      repoURL        = "https://grafana.github.io/helm-charts"
      targetRevision = "6.44.8"
      values         = <<EOT
sidecar:
  dashboard:
    enabled: true
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  hosts:
  - grafana.127.0.0.1.nip.io
EOT
    }
  }

  kindCluster = {
    config = {
      controlNodes = 1
      workerNodes  = 2
    }
  }
}
