# Database Service Manifest (Type: ExternalName Service)
resource "kubernetes_service_v1" "db_service" {
  metadata {
    name = "app-database"
  }
  spec {
    type = "ExternalName"
    externalName = "RDS-Endpoint-Link"
  }
}




