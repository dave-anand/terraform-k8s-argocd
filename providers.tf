terraform {
  required_version = ">= 1.3.0"

  required_providers {
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "~> 2.19.0"
    }

    helm = {
      source  = "hashicorp/helm"
      version = "~> 2.11.0"
    }

    null = {
      source  = "hashicorp/null"
      version = "~> 3.2.1"
    }
  }
}

provider "kubernetes" {
  config_path = var.kubeconfig_path
}

provider "helm" {
  kubernetes {
    config_path = var.kubeconfig_path
  }
}
