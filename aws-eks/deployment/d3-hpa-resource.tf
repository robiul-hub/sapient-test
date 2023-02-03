# Resource: Horizontal Pod Autoscaler
resource "kubernetes_horizontal_pod_autoscaler_v1" "hpa_myapp" {
  metadata {
    name = "hpa-app"
  }
  spec {
    max_replicas = 10
    min_replicas = 1
    scale_target_ref {
      api_version = "apps/v1"
      kind        = "Deployment"
      name        = kubernetes_deployment_v1.myapp.metadata[0].name
    }
    target_cpu_utilization_percentage = 50
  }
}