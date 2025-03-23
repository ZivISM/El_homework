###############################################################################
# EKS Blueprints
###############################################################################
module "eks_blueprints_addons" {
  source = "aws-ia/eks-blueprints-addons/aws"
  version = "1.19.0"

  cluster_name      = module.eks.cluster_name
  cluster_endpoint  = module.eks.cluster_endpoint
  cluster_version   = module.eks.cluster_version
  oidc_provider_arn = module.eks.oidc_provider_arn


  enable_aws_load_balancer_controller = var.enable_aws_load_balancer_controller
  aws_load_balancer_controller = {
    most_recent = true
    }
  
  enable_metrics_server = var.enable_metrics_server
  metrics_server = {
    most_recent = true
  }

  enable_kube_prometheus_stack = var.enable_kube_prometheus_stack
  kube_prometheus_stack = {
    most_recent = true
  }

  enable_aws_efs_csi_driver = var.enable_aws_efs_csi_driver
  aws_efs_csi_driver = {
    most_recent = true
  }
  

  eks_addons = {

    eks-pod-identity-agent = {
        most_recent = true
    }

    aws-ebs-csi-driver = {
      most_recent = true
      service_account_role_arn = module.ebs_csi_driver_irsa.iam_role_arn
    }
    
    coredns = {
      most_recent = true
      timeouts = {
        create = "25m"
        delete = "10m"
      }
    }

    vpc-cni = {
      most_recent = true 
    }
    
    kube-proxy = {
      most_recent = true
    }
  }

 
 depends_on = [
    module.ebs_csi_driver_irsa,
  ]
}


###############################################################################
# Supporting Resources
###############################################################################
module "ebs_csi_driver_irsa" {
  source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
  version = "~> 5.20"

  role_name_prefix = "${var.project}-ebs-csi-driver-"

  attach_ebs_csi_policy = true

  oidc_providers = {
    main = {
      provider_arn               = module.eks.oidc_provider_arn
      namespace_service_accounts = ["kube-system:ebs-csi-controller-sa"]
    }
  }

  tags = {
    "kubernetes.io/cluster/${module.eks.cluster_name}" = "owned"
  }

  depends_on = [
    module.eks
  ]
}