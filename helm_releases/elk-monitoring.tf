resource "kubernetes_namespace" "monitoring" {
  metadata {
    name = "monitoring"
  }
}

resource "helm_release" "elasticsearch" {
  name       = "elasticsearch"
  repository = "https://helm.elastic.co"
  chart      = "elasticsearch"

  timeout         = 240
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.monitoring.metadata.0.name

  set {
    name  = "volumeClaimTemplate.resources.requests.storage"
    value = "5Gi"
  }

  set {
    name  = "resources.requests.cpu"
    value = "250m"
  }

  set {
    name  = "resources.requests.memory"
    value = "1Gi"
  }

  set {
    name  = "resources.limits.cpu"
    value = "250m"
  }

  set {
    name  = "resources.limits.memory"
    value = "1Gi"
  }
}

resource "helm_release" "kibana" {
  name       = "kibana"
  repository = "https://helm.elastic.co"
  chart      = "kibana"

  timeout         = 240
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.monitoring.metadata.0.name
}

resource "helm_release" "metricbeat" {
  name       = "metricbeat"
  repository = "https://helm.elastic.co"
  chart      = "metricbeat"

  timeout         = 240
  cleanup_on_fail = true
  force_update    = false
  namespace       = kubernetes_namespace.monitoring.metadata.0.name
}