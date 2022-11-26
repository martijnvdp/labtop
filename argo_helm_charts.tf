locals {

  helmCharts = {

    cert-manager = var.applications.cert-manager ? {
      repoURL        = "https://charts.jetstack.io"
      targetRevision = "1.10.1"
      values         = <<EOT
fullNameOverride: cert-manager
installCRDs: true
EOT
    } : null

    datadog = local.deployDatadog ? {
      createNamespace = false
      repoURL         = "https://helm.datadoghq.com"
      targetRevision  = "3.3.3"
      values          = <<EOT
agents:
  useConfigMap: true
  customAgentConfig:
    hostname: labtop
clusterAgent:
  tokenExistingSecret: ${var.datadog.secret}
datadog:
  apiKeyExistingSecret: ${var.datadog.secret}
  appKeyExistingSecret: ${var.datadog.secret}
  site: ${var.datadog.site}
EOT
    } : null

    external-secrets = var.applications.externalSecrets ? {
      createNamespace = true
      repoURL         = "https://charts.external-secrets.io"
      targetRevision  = "0.6.1"
      values          = <<EOT
certController:
  create: false
serviceAccount:
  name: external-secrets
webhook:
  create: false
EOT
    } : null

    gatekeeper = var.applications.gatekeeper ? {
      repoURL        = "https://open-policy-agent.github.io/gatekeeper/charts"
      targetRevision = "3.10.0"
      values         = <<EOT
fullNameOverride: gatekeeper
replicas: 1
EOT
    } : null

    grafana = var.applications.grafana ? {
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
    } : null

    ingress-nginx = var.kindCluster.config.ingress ? {
      repoURL        = "https://kubernetes.github.io/ingress-nginx"
      targetRevision = "v4.4.0"
      values         = <<EOT
fullnameOverride: ingress-nginx
controller:
  extraArgs:
    publish-status-address: localhost
  hostPort:
    enabled: true
  publishService:
    enabled: false
  service:
    type: NodePort
  tolerations:
    - effect: NoSchedule
      key: node-role.kubernetes.io/master
      operator: Equal
    - effect: NoSchedule
      key: node-role.kubernetes.io/control-plane
      operator: Equal
  watchIngressWithoutClass: true
  nodeSelector:
    ingress-ready: "'true'"
    kubernetes.io/os: linux
EOT
    } : null

    kube-state-metrics = var.applications.kube-state-metrics ? {
      repoURL        = "https://prometheus-community.github.io/helm-charts"
      targetRevision = "4.23.0"
      values         = <<EOT
fullnameOverride: kube-state-metrics
EOT
    } : null

    labtop-info = var.applications.labtop-info ? {
      namespace      = var.argoCD.namespace
      repoURL        = "https://martijnvdp.github.io/helm-repo"
      targetRevision = "0.0.1"
      values         = <<EOT
ingress:
  enabled: ${var.kindCluster.config.ingress}
EOT
    } : null

    game2048 = var.applications.game2048 ? {
      repoURL        = "https://martijnvdp.github.io/helm-repo"
      targetRevision = "0.1.0"
      values         = <<EOT
fullNameOverride: game2048
replicaCount: 2
ingress:
  enabled: true
  annotations:
    kubernetes.io/ingress.class: nginx
  host: game2048.127.0.0.1.nip.io
EOT
    } : null

    prometheus = var.applications.prometheus ? {
      repoURL        = "https://prometheus-community.github.io/helm-charts"
      targetRevision = "17.0.2"
      values         = <<EOT
fullNameOverride: prometheus
server:
  ingress:
      enabled: true
    annotations:
      kubernetes.io/ingress.class: nginx
        hosts:
        - prometheus.127.0.0.1.nip.io
EOT
    } : null
  }

  defaultCharts = [for chart, values in merge(local.helmCharts, var.helmCharts) : {
    name      = try(values.name, "") != "" ? values.name : chart
    namespace = var.argoCD.namespace
    project   = "labtop"

    destination = {
      name      = "in-cluster"
      namespace = try(values.namespace, "") != "" ? values.namespace : chart
    }

    source = {
      chart          = try(values.chart, "") != "" ? values.chart : chart
      repoURL        = values.repoURL
      targetRevision = values.targetRevision

      helm = {
        values     = replace(try(values.values, ""), "\r\n", "\n")
        parameters = try(values.parameters, [])
      }
    }

    syncPolicy = {

      automated = {
        prune    = true
        selfHeal = true
      }

      syncOptions = ["CreateNamespace=${try(values.createNamespace, true)}"]
    }
    } if values != null
  ]
}
