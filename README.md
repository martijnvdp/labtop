# LaBTop
Setup a kubernetes cluster lab using terraform

# requirements

- kind
- docker
- terraform

# usage

```hcl
module "eks" {
  source = "git::https://github.com/martijnvdp/labtop.git?ref=v0.0.1"

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

<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kind | 0.0.2-u2 |

## Providers


## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kindCluster | Cluster settings | <pre>object({<br>    name    = optional(string, "lab")<br>    version = optional(string, "v1.22.15")<br>    config = optional(object({<br>      disableDefaultCNI = optional(bool, true)<br>      controlNodes      = optional(number, 1)<br>      workerNodes       = optional(number, 3)<br>    }), {})<br>  })</pre> | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
