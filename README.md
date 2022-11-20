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

No provider.

## Inputs

No input.

## Outputs

No output.

<!--- END_TF_DOCS --->
