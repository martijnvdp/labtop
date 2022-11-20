# LaBTop
Setup a kubernetes cluster lab using terraform

# requirements

- kind
- docker
- terraform

# usage

```hcl
module "eks" {
  source = "git::https://github.com/martijnvdp/labtop.git?ref=v0.0.4"

  kindCluster = {
    name    = "labtop"
    version = "v1.21.14"

    config = {
      controlNodes = 1
      workerNodes  = 2
    }
  }
}
```

## tools after install

- Hubble UI: http://hubble-ui.127.0.0.1.nip.io/
- ArgoCD: http://argo-cd.127.0.0.1.nip.io

## argoCD
Get Base64 encoded default admin password:
` $(kubectl -n argo-cd get secret argocd-initial-admin-secret -o jsonpath="{.data}"|ConvertFrom-Json).password|ConvertFrom-Base64`
<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kind | 0.0.15 |

## Providers

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kind | 0.0.15 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| argoCD | ArgoCD controller settings | <pre>object({<br>    chart      = optional(string, "argo-cd")<br>    name       = optional(string, "argo-cd")<br>    namespace  = optional(string, "argo-cd")<br>    repository = optional(string, "https://argoproj.github.io/argo-helm")<br>    timeout    = optional(number, 600)<br>    version    = optional(string, "v5.7.0") # higher version requires k8 1.22+<br>  })</pre> | `{}` | no |
| cilium | Cilium settings | <pre>object({<br>    chart      = optional(string, "cilium")<br>    name       = optional(string, "cilium")<br>    namespace  = optional(string, "kube-system")<br>    repository = optional(string, "https://helm.cilium.io/")<br>    version    = optional(string, "v1.11.11")<br>    settings = optional(object({<br>      kubeProxyReplacement = optional(string, "strict")<br>      k8sServiceHost       = optional(string, "labtop-control-plane")<br>      k8sServicePort       = optional(number, 6443)<br>      ipamMode             = optional(string, "kubernetes")<br>      externalIPs = optional(object({<br>        enabled = optional(bool, true)<br>      }), {})<br>      hostPort = optional(object({<br>        enabled = optional(bool, true)<br>      }), {})<br>      hostServices = optional(object({<br>        enabled = optional(bool, false)<br>      }), {})<br>      hubble = optional(object({<br>        enabled = optional(bool, true)<br>        relay = optional(object({<br>          enabled = optional(bool, true)<br>        }), {})<br>        ui = optional(object({<br>          enabled = optional(bool, true)<br>          ingress = optional(object({<br>            enabled     = optional(bool, true)<br>            annotations = optional(map(string), { "kubernetes.io/ingress.class" = "nginx" })<br>            hosts       = optional(list(string), ["hubble-ui.127.0.0.1.nip.io"])<br>          }), {})<br>        }), {})<br>      }), {})<br>      nodePort = optional(object({<br>        enabled = optional(bool, true)<br>      }), {})<br>    }), {})<br>  })</pre> | `{}` | no |
| ingressController | Ingress controller settings | <pre>object({<br>    chart      = optional(string, "ingress-nginx")<br>    name       = optional(string, "ingress-nginx")<br>    namespace  = optional(string, "ingress-nginx")<br>    repository = optional(string, "https://kubernetes.github.io/ingress-nginx")<br>    values     = optional(string, "")<br>    version    = optional(string, "v4.4.0")<br>  })</pre> | `{}` | no |
| kindCluster | Cluster settings | <pre>object({<br>    name    = optional(string, "lab")<br>    version = optional(string, "v1.22.15")<br>    config = optional(object({<br>      controlNodes      = optional(number, 1)<br>      disableDefaultCNI = optional(bool, true)<br>      ingress           = optional(bool, true)<br>      workerNodes       = optional(number, 3)<br>    }), {})<br>  })</pre> | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->

## WSL Windows Cilium enterprise
to use cilium enterprise rebuild custom wsl kernel 
https://harthoover.com/compiling-your-own-wsl2-kernel/
install dwarfes before rebuilding the wsl kernel
and rebuild using the latest version wsl example `WSL_COMMIT_REF=linux-msft-wsl-5.10.102.1`
