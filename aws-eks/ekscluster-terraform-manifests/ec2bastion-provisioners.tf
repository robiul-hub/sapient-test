# Create a Null Resource and Provisioners
resource "null_resource" "copy_ec2_keys" {
  depends_on = [module.ec2_public]

  # Connection Block for Provisioners to connect to EC2 Instance
  count = length(module.vpc.public_subnets)
  connection {
    type     = "ssh"
    host     = aws_eip.bastion_eip[count.index].public_ip
    user     = "ec2-user"
    password = ""
    private_key = file("key/bastion-key.pem")
  }

  ## File Provisioner: Copies the terraform-key.pem file to /tmp/terraform-key.pem
  provisioner "file" {
    source      = "private-key/bastion-key.pem"
    destination = "/tmp/bastion-key.pem"
  }
  ## Remote Exec Provisioner: Using remote-exec provisioner fix the private key permissions on Bastion Host
  provisioner "remote-exec" {
    inline = [
      "sudo chmod 400 /tmp/bastion-key.pem"
    ]
  }
}