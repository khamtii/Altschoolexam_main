# Data for availability Zones
data "aws_availability_zones" "available" {}

# Create VPC
module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name                 = local.vpc_name
  cidr                 = local.vpc_cidr
  azs                  = slice(data.aws_availability_zones.available.names, 0, 4)
  private_subnets      = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24", "10.0.13.0/24"]
  public_subnets       = ["10.0.5.0/24", "10.0.6.0/24", "10.0.7.0/24", "10.0.8.0/24"]
  intra_subnets        = ["10.0.9.0/24", "10.0.10.0/24", "10.0.11.0/24", "10.0.12.0/24"]
  enable_nat_gateway   = true
  single_nat_gateway   = true
  enable_dns_hostnames = true
  enable_flow_log      = false


  public_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/elb"                      = "1"
  }

  private_subnet_tags = {
    "kubernetes.io/cluster/${local.cluster_name}" = "shared"
    "kubernetes.io/role/internal-elb"             = "1"
  }
}
