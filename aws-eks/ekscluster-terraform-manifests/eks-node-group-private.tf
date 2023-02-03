# Create AWS EKS Node Group - Private

resource "aws_eks_node_group" "eks_ng_private" {
  cluster_name = aws_eks_cluster.eks_cluster.name
  //count = length(module.vpc.public_subnets)
  node_group_name = "${local.name}-eks-ng-private"
  node_role_arn   = aws_iam_role.eks_nodegroup_role.arn
  subnet_ids      = module.vpc.private_subnets
  version         = var.cluster_version

  ami_type       = "AL2_x86_64"
  capacity_type  = "ON_DEMAND"
  disk_size      = 20
  instance_types = ["t3.medium"]

  remote_access {
    ec2_ssh_key = "eks-terraform-key"
    //ec2_ssh_key               = module.key_pair.key_pair_name
    //source_security_group_ids = [aws_security_group.remote_access.id]  
  }

  scaling_config {
    desired_size = 3
    min_size     = 3
    max_size     = 6
  }

  # Desired max percentage of unavailable worker nodes during node group update.
  update_config {
    max_unavailable = 1
  }

    depends_on = [
    aws_iam_role_policy_attachment.eks-AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.eks-AmazonEKS_CNI_Policy,
    aws_iam_role_policy_attachment.eks-AmazonEC2ContainerRegistryReadOnly,
  ]
  tags = {
    Name = "Private-Node-Group"
    # Cluster Autoscaler Tags
    "k8s.io/cluster-autoscaler/${local.eks_cluster_name}" = "owned"
    "k8s.io/cluster-autoscaler/enabled"                   = "TRUE"
  }
}

