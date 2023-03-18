output "region" {
  description = "AWS region"
  value       = var.region
}

output "endpoint" {
  value = aws_eks_cluster.eks-cluster.endpoint
}

output "cluster_name" {
  value = aws_eks_cluster.eks-cluster.name
}
