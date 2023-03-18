
provider "aws" {
  region = var.region
}

# Data for aws caller identity
data "aws_caller_identity" "current" {}


locals {
  name         = join("-", ["project1", "eks", "cluster"])
  vpc_name     = join("", ["project1", "eks", "cluster"])
  cluster_name = join("", ["project1", "eks", "cluster"])
  azs          = slice(data.aws_availability_zones.available.names, 0, 4)

  vpc_cidr = "10.0.0.0/16"

  tags = {
    name   = local.name
    school = "project1"
  }

}


provider "helm" {
  kubernetes {
    host                   = data.aws_eks_cluster.eks_cluster.endpoint
    cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
    exec {
      api_version = "client.authentication.k8s.io/v1beta1"
      args        = ["eks", "get-token", "--cluster-name", data.aws_eks_cluster.eks_cluster.name]
      command     = "aws"
    }
  }
}


provider "kubernetes" {
  host                   = data.aws_eks_cluster.eks_cluster.endpoint
  cluster_ca_certificate = base64decode(data.aws_eks_cluster.eks_cluster.certificate_authority.0.data)
  token                  = data.aws_eks_cluster_auth.eks_cluster.token
  #load_config_file       = false
}

