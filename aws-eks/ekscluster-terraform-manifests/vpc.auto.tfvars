# VPC Variables
vpc_name                               = "eks-vpc"
vpc_cidr_block                         = "10.0.0.0/16"
vpc_public_subnets                     = ["10.0.51.0/24", "10.0.52.0/24", "10.0.53.0/24"]
vpc_private_subnets                    = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
vpc_database_subnets                   = ["10.0.151.0/24", "10.0.152.0/24", "10.0.153.0/24"]
vpc_create_database_subnet_group       = true
vpc_create_database_subnet_route_table = true
vpc_enable_nat_gateway                 = true
vpc_single_nat_gateway                 = false
vpc_one_nat_gateway_per_az             = true
