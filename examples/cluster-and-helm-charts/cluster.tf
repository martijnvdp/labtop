locals {
  helm_apps = [{
    name      = "cert-manager"
    namespace = "argo-cd"
    project   = "labtop"

    destination = {
      namespace = "cert-manager"
      name      = "in-cluster"
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

    syncPolicy = {

      automated = {
        prune    = true
        selfHeal = true
      }
      syncOptions = ["CreateNamespace=true"]
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
