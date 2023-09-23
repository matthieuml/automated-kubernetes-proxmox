terraform {

  required_version = ">= 0.13.0"

  required_providers {
    helm = {
      source  = "hashicorp/helm"
      version = "2.11.0"
    }
    kubernetes = {
      source  = "hashicorp/kubernetes"
      version = "2.23.0"
    }
  }
}

provider "helm" {
  kubernetes {
    config_path    = "~/.kube/config"
    config_context = "default"
  }
}

provider "kubernetes" {
  config_path    = "~/.kube/config"
  config_context = "default"
}