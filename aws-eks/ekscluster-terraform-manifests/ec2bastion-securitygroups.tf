# Security Group for Public Bastion Host
module "public_bastion_sg" {
  source  = "terraform-aws-modules/security-group/aws"
  version = "4.5.0"

  name        = "${local.name}-public-bastion-sg"
  description = "Security Group with SSH port open."
  vpc_id      = module.vpc.vpc_id
  # Ingress Rules & CIDR Blocks
  ingress_rules       = ["ssh-tcp"]
  ingress_cidr_blocks = ["53.10.0.0/24"] // Need desired CIDR/IPs for SSH as per reqirement of security
  # Egress Rule - all-all open
  egress_rules = ["all-all"]
  tags         = local.common_tags
}