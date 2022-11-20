# Usage
<!--- BEGIN_TF_DOCS --->
## Requirements

| Name | Version |
|------|---------|
| helm | >= 2.2.0 |
| kind | 0.0.2-u2 |

## Providers

| Name | Version |
|------|---------|
| kind | 0.0.2-u2 |

## Inputs

| Name | Description | Type | Default | Required |
|------|-------------|------|---------|:--------:|
| kindCluster | Cluster settings | <pre>object({<br>    name    = optional(string, "lab")<br>    version = optional(string, "v1.22.15")<br>    config = optional(object({<br>      disableDefaultCNI = optional(bool, true)<br>      controlNodes      = optional(number, 1)<br>      workerNodes       = optional(number, 3)<br>    }), {})<br>  })</pre> | `{}` | no |

## Outputs

No output.

<!--- END_TF_DOCS --->
