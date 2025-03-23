module "infra" {
  source = "./cluster"

###################################################
# GENERAL
###################################################

  project = "elbit-test"
  region = "us-east-1"
  tags = {
    "Project" = "elbit-test"
  }

###################################################
# VPC
###################################################

  vpc_cidr = "10.0.0.0/16"
  num_zones = 2 
  single_nat_gateway = true
  enable_nat_gateway = true
  enable_dns_hostnames = true
  enable_dns_support = true
  one_nat_gateway_per_az = false
  public_subnet_tags = {
    "kubernetes.io/role/elb" = "1"
  }
  private_subnet_tags = {
    "kubernetes.io/role/internal-elb" = "1"
  }
  vpc_tags = {
    "Project" = "elbit-test"
  }

###################################################
# EKS
###################################################

  eks_enabled = true
  k8s_version = "1.32"
  eks_managed_node_groups = {
    "default" = {
      "instance_types" = ["t3.medium"]
    }
    "spot" = {
      "instance_types" = ["t3.medium"]
      "capacity_type" = "SPOT"
    }
  }

  map_users = [
    {
      userarn = "arn:aws:iam::123456789012:user/localadmin"
      username = "localadmin"
      groups = ["system:masters"]
    }
  ]

  map_accounts = ["123456789012"] # Main AWS account ID

  map_roles = [
    {
      rolearn  = "arn:aws:iam::123456789012:role/eks-admin"
      username = "eks-admin" 
      groups   = ["system:masters"]
    }
  ]
###################################################
# BLUEPRINTS
###################################################

  enable_aws_load_balancer_controller = false
  enable_metrics_server = true
  enable_kube_prometheus_stack = false
  enable_aws_efs_csi_driver = false
  enable_keda = true
}