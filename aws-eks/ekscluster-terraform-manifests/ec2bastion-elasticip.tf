# Create Elastic IP for Bastion Host
# Resource - depends_on Meta-Argument
resource "aws_eip" "bastion_eip" {
  depends_on = [module.ec2_public, module.vpc]
  count      = length(module.vpc.public_subnets)
  vpc        = true
  tags       = local.common_tags
}

