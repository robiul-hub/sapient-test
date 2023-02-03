# Kubernetes Deployment Manifest
resource "kubernetes_deployment_v1" "myapp" {
  metadata {
    name = "app-deployment"
    labels = {
      app = "myapp"
    }
  } 
 
  spec {
    replicas = 3

    selector {
      match_labels = {
        app = "myapp"
      }
    }

    template {
      metadata {
        labels = {
          app = "myapp"
        }
      }

      spec {
        affinity {
          node_affinity {
            required_during_scheduling_ignored_during_execution {
              node_selector_term {
                match_expressions {
                  key      = "kubernetes.io/aws_eks_node_group.eks_ng_private.node_group_name}"
                  operator = "Exists"
                  values   = [""]
                }
              }
           }
          }
        } 
        container {
          image = "ECR-Repo-URL/Pharmastore:1.0.0"
          name  = "myapp"
          liveness_probe {
            http_get {
              path = "/"
              port = 80
            }
            initial_delay_seconds = 30
            period_seconds        = 30
          }
          resources {
            limits = {
              cpu    = "0.5"
              memory = "512Mi"
            }
            requests = {
              cpu    = "250m"
              memory = "256Mi"
            }
          }
          env = {
            - name = "DB_HOSTNAME"
              value = "mysql"            
            - name = "DB_PORT"
              value = "3306"            
            - name = "DB_NAME"
              value = "app-database"            
            - name = "DB_USERNAME"
              value = "admin"        # RDS DB Username is dbadmin     
            - name = "DB_PASSWORD"
              valueFrom = {
                secretKeyRef = {
                  name = "mysql-db-password"
                  key = "db-password"
                }
              }
          }
          port {
            container_port = 80
          }
          }
        }
      }
    }
}

