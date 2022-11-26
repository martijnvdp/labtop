# LaBTop
Deploy in a few minutes a local kubernetes cluster lab using terraform with cilium, ingress, ArgoCD

# requirements

- kind `go install sigs.k8s.io/kind@v0.17.0`
- docker desktop `https://www.docker.com/products/docker-desktop/`
- terraform `https://developer.hashicorp.com/terraform/downloads`

see all tools https://github.com/martijnvdp/labtop/tree/dependency#client-tools

Important: On windows with WSL you need to rebuild a WSL kernel for cilium:
more info https://github.com/martijnvdp/labtop#wsl-windows-cilium-enterprise

# usage example

```hcl
module "eks" {
  source = "git::https://github.com/martijnvdp/labtop.git?ref=v0.1.0"

  kindCluster = {
    name    = "labtop"

    config = {
      controlNodes = 1
      workerNodes  = 2
    }
  }
}
```
`terraform init` & `terraform plan` & `terraform apply`

## tools after install

- ArgoCD: http://argo-cd.127.0.0.1.nip.io
- Game 2048: http://game2048.127.0.0.1.nip.io
- Hubble UI: http://hubble-ui.127.0.0.1.nip.io/
- LaBTop info: http://labtop-info.127.0.0.1.nip.io/ 

## argoCD
Get Base64 encoded default admin password:
http://labtop-info.127.0.0.1.nip.io/

## WSL Windows Cilium enterprise
to use cilium on windows icw WSL you need to rebuild a custom WSL kernel 

a script for this can be found here:  
`https://raw.githubusercontent.com/martijnvdp/bash-code-snippets/main/wsl2/build-wsl2-kernel.sh`
sources: `https://github.com/microsoft/WSL2-Linux-Kernel/releases`


to download and run the script, open a wsl ubuntu terminal and copy this line:
```
curl https://raw.githubusercontent.com/martijnvdp/bash-code-snippets/main/wsl2/build-wsl2-kernel.sh -o ./build-wsl-kernel.sh && sudo chmod +x ./build-wsl-kernel.sh && sudo ./build-wsl-kernel.sh
```

to install ubuntu: 
`wsl.exe --install -d ubuntu`  
or to list available distributions: `wsl.exe -l -o`

after the script is finished rebuilding check in ubuntu/wsl the version with `uname -r`  
this should now return the latest version with cilium at the end

## Client tools

- terraform: https://developer.hashicorp.com/terraform/downloads
- helm: https://helm.sh/docs/intro/install/
- kind `go install sigs.k8s.io/kind@v0.17.0`
- kubectl: https://kubernetes.io/docs/tasks/tools/install-kubectl-windows/
- docker desktop: https://www.docker.com/products/docker-desktop/

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kind | 0.0.15 |
| kubernetes | 2.16.0 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kind | 0.0.15 |
| kubernetes | 2.16.0 |
| null | n/a |
| random | n/a |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| applications | Selection of charts to install in ArgoCD | <pre>object({<br>    cert-manager       = optional(bool, false)<br>    externalSecrets    = optional(bool, true)<br>    game2048           = optional(bool, true)<br>    gatekeeper         = optional(bool, true)<br>    grafana            = optional(bool, false)<br>    kube-state-metrics = optional(bool, false)<br>    labtop-info        = optional(bool, true)<br>    prometheus         = optional(bool, false)<br>  })</pre> | `{}` | no |
| argoCD | ArgoCD deployment settings | <pre>object({<br>    chart      = optional(string, "argo-cd")<br>    name       = optional(string, "argo-cd")<br>    namespace  = optional(string, "argo-cd")<br>    repository = optional(string, "https://argoproj.github.io/argo-helm")<br>    timeout    = optional(number, 600)<br>    version    = optional(string, "v5.14.1")<br>  })</pre> | `{}` | no |
| argoCDApplications | ArgoCD Applications | <pre>list(object({<br>    name      = string<br>    namespace = optional(string, "argo-cd")<br>    project   = optional(string, "labtop")<br>    destination = object({<br>      namespace = string<br>      name      = optional(string, "in-cluster")<br>    })<br>    source = object({<br>      chart          = optional(string, null)<br>      path           = optional(string, null)<br>      repoURL        = optional(string, null)<br>      targetRevision = optional(string, null)<br>      helm = optional(object({<br>        values = optional(string, null)<br>      }), null)<br>    })<br>    syncPolicy = optional(object({<br>      automated = optional(object({<br>        prune    = optional(bool, true)<br>        selfHeal = optional(bool, true)<br>      }), {})<br>      syncOptions = optional(list(string), ["CreateNamespace=true"])<br>    }), {})<br>  }))</pre> | `[]` | no |
| argoCDApps | ArgoCD application(sets) and projects helm chart settings | <pre>object({<br>    chart                   = optional(string, "argocd-apps")<br>    deploy_default_projects = optional(bool, true)<br>    name                    = optional(string, "argocd-apps")<br>    namespace               = optional(string, "argo-cd")<br>    repository              = optional(string, "https://argoproj.github.io/argo-helm")<br>    version                 = optional(string, "v0.0.3")<br>  })</pre> | `{}` | no |
| argoCDProjects | ArgoCD Projects | <pre>list(object({<br>    name        = string<br>    namespace   = optional(string, "argo-cd")<br>    project     = optional(string, "labtop")<br>    sourceRepos = optional(list(string), ["'*'"])<br>    clusterResourceWhitelist = optional(list(object({<br>      kind  = optional(list(string), ["'*'"])<br>      group = optional(list(string), ["'*'"])<br>    })), [{}])<br>    destinations = optional(list(object({<br>      namespace = optional(list(string), ["'*'"])<br>      name      = optional(string, "in-cluster")<br>      server    = optional(string, "https://kubernetes.default.svc")<br>    })), [{}])<br>  }))</pre> | `[]` | no |
| argoCDRepositories | Repositories to add to ArgoCD. | <pre>map(object({<br>    url     = string<br>    name    = string<br>    project = optional(string, "labtop")<br>    type    = string<br>  }))</pre> | `{}` | no |
| argoCDRepositoryCredentialTemplates | Repository credential templates | <pre>map(object({<br>    username = string<br>    password = string<br>    url      = string<br>  }))</pre> | `{}` | no |
| cilium | Cilium settings | <pre>object({<br>    chart      = optional(string, "cilium")<br>    name       = optional(string, "cilium")<br>    namespace  = optional(string, "kube-system")<br>    repository = optional(string, "https://helm.cilium.io/")<br>    version    = optional(string, "v1.12.4")<br>  })</pre> | `{}` | no |
| datadog | Datadog agent deployment settings | <pre>object({<br>    namespace = optional(string, "datadog")<br>    secret    = optional(string, "datadog-keys")<br>    site      = optional(string, "datadoghq.eu")<br>    version   = optional(string, "datadog")<br>  })</pre> | `{}` | no |
| datadogKeys | Datadog keys | <pre>object({<br>    api = string<br>    app = string<br>  })</pre> | `null` | no |
| helmCharts | Map of Helm charts to install in ArgoCD | <pre>map(object({<br>    chart           = optional(string, "")<br>    name            = optional(string, "")<br>    createNamespace = optional(bool, true)<br>    namespace       = optional(string, "")<br>    repoURL         = string<br>    targetRevision  = string<br>    values          = optional(string, "")<br>  }))</pre> | `{}` | no |
| kindCluster | Cluster settings | <pre>object({<br>    name         = optional(string, "labtop")<br>    version      = optional(string, "v1.22.15")<br>    waitForReady = optional(bool, false)<br>    config = optional(object({<br>      controlNodes      = optional(number, 1)<br>      disableDefaultCNI = optional(bool, true)<br>      ingress           = optional(bool, true)<br>      workerNodes       = optional(number, 0)<br>    }), {})<br>  })</pre> | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
