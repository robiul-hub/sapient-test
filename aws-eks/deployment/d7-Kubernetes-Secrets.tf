# Database secrets
resource "kubernetes_secret" "db_secret" {
  metadata {
    name = "mysql-db-password"
  }

  data = {
     password = "ZGJwYXNzd29yZDEx"
  }

  type = "Opaque"
}