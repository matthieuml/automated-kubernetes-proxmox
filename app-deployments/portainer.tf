resource "kubernetes_namespace" "portainer" {
  metadata {
    name = "portainer"
  }
}

resource "helm_release" "portainer" {
  name       = "portainer"
  repository = "https://portainer.github.io/k8s/"
  chart      = "portainer"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.portainer.metadata.0.name
}