resource "kubernetes_namespace" "argo-cd" {
  metadata {
    name = "argo-cd"
    labels = {
      istio-injection = "enabled"
    }
  }

  depends_on = [helm_release.istiod]
}

resource "helm_release" "argo-cd" {
  name       = "argo-cd"
  repository = "https://argoproj.github.io/argo-helm"
  chart      = "argo-cd"

  timeout         = 120
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.argo-cd.metadata.0.name

  set {
    name  = "configs.params.server\\.insecure"
    value = true
  }
}
