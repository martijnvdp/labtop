terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.2.0"
    }
    kind = {
      source  = "unicell/kind"
      version = "0.0.2-u2"
    }
  }
}
