resource "kubernetes_namespace" "argo-cd" {
  metadata {
    name = "argo-cd"
  }
}

resource "helm_release" "argo-cd" {
  name       = "argocd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.argo-cd.metadata.0.name
}