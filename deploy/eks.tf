# Create EKS Cluster
resource "aws_eks_cluster" "eks-cluster" {
  name     = local.cluster_name
  role_arn = aws_iam_role.EKS-Cluster-Role.arn

  vpc_config {
    security_group_ids = [aws_security_group.clustersg.id, aws_security_group.node-clustersg.id]
    subnet_ids         = flatten([module.vpc.private_subnets, module.vpc.private_subnets])

  }

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSClusterPolicy,
    aws_iam_role_policy_attachment.AmazonEKSServicePolicy,
  ]

}


# Node group for Sock-Shop
resource "aws_eks_node_group" "sockshop" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "sockshop"
  node_role_arn   = aws_iam_role.Node-Group-Role.arn
  subnet_ids      = flatten(module.vpc.private_subnets)
  remote_access {
    ec2_ssh_key = "aws"
  }

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.medium"]
  disk_size      = 20

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]

  tags = {
    node_group = "sockshop"
  }

}

# Node group for Portfolio Website
resource "aws_eks_node_group" "webapp" {
  cluster_name    = aws_eks_cluster.eks-cluster.name
  node_group_name = "webapp"
  node_role_arn   = aws_iam_role.Node-Group-Role.arn
  subnet_ids      = flatten(module.vpc.private_subnets)
  remote_access {
    ec2_ssh_key = "aws"
  }

  scaling_config {
    desired_size = 1
    max_size     = 3
    min_size     = 1
  }

  instance_types = ["t2.medium"]
  disk_size      = 20

  depends_on = [
    aws_iam_role_policy_attachment.AmazonEKSWorkerNodePolicy,
    aws_iam_role_policy_attachment.AmazonEC2ContainerRegistryReadOnly,
    aws_iam_role_policy_attachment.AmazonEKS_CNI_Policy
  ]

  tags = {
    node_group = "webapp"
  }
}

# Data for Cluster Auth
data "aws_eks_cluster_auth" "eks_cluster" {
  name = aws_eks_cluster.eks-cluster.name
}

data "aws_eks_cluster" "eks_cluster" {
  name = aws_eks_cluster.eks-cluster.name
}
