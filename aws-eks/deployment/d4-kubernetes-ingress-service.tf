# Kubernetes Service Manifest (Type: Load Balancer)
resource "kubernetes_ingress_v1" "ingress" {
  metadata {
    name = "ingress-ssl-service"
    annotations = {
      # Load Balancer DNS Name
      "alb.ingress.kubernetes.io/load-balancer-name" = "eks-ingress-ssl"
      # Ingress Core Settings
      "alb.ingress.kubernetes.io/scheme" = "internet-facing"
      # Health Check Settings
      "alb.ingress.kubernetes.io/healthcheck-protocol" =  "HTTP"
      "alb.ingress.kubernetes.io/healthcheck-port" = "traffic-port"
      "alb.ingress.kubernetes.io/healthcheck-interval-seconds" = 15
      "alb.ingress.kubernetes.io/healthcheck-timeout-seconds" = 5
      "alb.ingress.kubernetes.io/success-codes" = 200
      "alb.ingress.kubernetes.io/healthy-threshold-count" = 2
      "alb.ingress.kubernetes.io/unhealthy-threshold-count" = 2
      ## SSL Settings
      "alb.ingress.kubernetes.io/listen-ports" = jsonencode([{"HTTPS" = 443}, {"HTTP" = 80}])
      "alb.ingress.kubernetes.io/certificate-arn" =  "${aws_acm_certificate.acm_cert.arn}"
      # SSL Redirect Setting
      "alb.ingress.kubernetes.io/ssl-redirect" = 443
    }    
  }
  spec {
    ingress_class_name = "my-aws-ingress-class" # Ingress Class            
    default_backend {
      service {
        name = kubernetes_service_v1.myapp_np_service.metadata[0].name
        port {
          number = 80
        }
      }
    }

    
  }
}




