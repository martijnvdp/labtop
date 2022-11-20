terraform {
  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = ">= 2.2.0"
    }
    kind = {
      source  = "tehcyx/kind"
      version = "0.0.15"
    }
  }
}

