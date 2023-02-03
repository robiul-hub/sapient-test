# Bastion Host - EC2 Instance that will be created in VPC Public Subnets
module "ec2_public" {
  source                 = "terraform-aws-modules/ec2-instance/aws"
  version                = "3.3.0"
  count                  = length(module.vpc.public_subnets)
  name                   = "${local.name}-BastionHost"
  ami                    = data.aws_ami.amzlinux2.id
  instance_type          = var.instance_type
  key_name               = var.instance_keypair
  subnet_id              = module.vpc.public_subnets[count.index]
  vpc_security_group_ids = [module.public_bastion_sg.security_group_id]
  tags                   = local.common_tags
}