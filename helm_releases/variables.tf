variable "kubeconfig_path" {
  type        = string
  description = "The path to the kubeconfig file to use for authenticating to the Kubernetes cluster."
}

variable "kube_config_context" {
  type        = string
  description = "The name of the Kubernetes context to use for authenticating to the Kubernetes cluster."
}