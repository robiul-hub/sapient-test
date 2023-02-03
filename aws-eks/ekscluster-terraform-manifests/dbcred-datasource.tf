
/*
// Access the Database secrets from AWS Secrets Manager
data "aws_secretsmanager_secret" "db_secret" {
      name = "db-secrets" 
    }
data "aws_secretsmanager_secret_version" "db_secret_ver" {
      secret_id = data.aws_secretsmanager_secret.db_secret.id
    }

output "database_secret" {
  value = data.aws_secretsmanager_secret_version.db_secret_ver.secret_string
}
*/


