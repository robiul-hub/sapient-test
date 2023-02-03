// Creating Amazon RDS Database using terraform module

module "rds_db_instance" {
  source  = "terraform-aws-modules/rds/aws//modules/db_instance"
  version = "5.3.0"

  identifier              = "app-database"
  multi_az                = true
  db_subnet_group_name    = "${module.vpc.database_subnet_group}"
  db_name                 = "app-database"
  allocated_storage       = 20
  storage_type            = "gp2"
  engine                  = "mysql"
  engine_version          = "5.7"
  instance_class          = "db.m5" 
  username                = "admin"
  password                = "admin"    //data.aws_secretsmanager_secret_version.db_secret_ver.secret_string
  deletion_protection     = true
  port                    = 3306
  backup_retention_period = 35
  backup_window           = "22:00-23:00"
  maintenance_window      = "Mon:00:00-Mon:03:00"

  tags = local.common_tags

}