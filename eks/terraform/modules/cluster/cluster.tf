# module "irsa-ebs-csi" {
#   source  = "terraform-aws-modules/iam/aws//modules/iam-role-for-service-accounts-eks"
#   version = "5.3.1"

#   # Module variables
#   role_name = "irsa-ebs-csi"
#   #attach_eks_cluster_policy = true
#   # attach_eks_node_policy    = true
#   attach_ebs_csi_policy = true
#   oidc_providers        = ["https://oidc.eks.${var.region}.amazonaws.com/id/${module.eks.cluster_id}"]
#   #service_accounts          = ["ebs-csi-controller-sa"]
# }


module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "20.8.5"

  cluster_name    = format("%s-%s", "${var.prefix}", "${var.eks_resource_names["cluster"]}")
  cluster_version = var.cluster_version

  cluster_endpoint_public_access           = var.enable
  enable_cluster_creator_admin_permissions = var.enable

  cluster_addons = {
    # aws-ebs-csi-driver = {
    #   service_account_role_arn = module.irsa-ebs-csi.iam_role_arn
    # }
  }

  vpc_id     = var.vpc_id
  subnet_ids = var.private_subnets

  eks_managed_node_group_defaults = {
    ami_type = "AL2_x86_64"

  }

  eks_managed_node_groups = {
    one = {
      name               = format("%s-%s", "${var.prefix}", "${var.eks_resource_names["backend"]}")
      instance_types     = var.backend_instances
      security_group_ids = ["${var.backend_sg}"]

      min_size     = var.backend_min
      max_size     = var.backend_max
      desired_size = var.backend_desired
    }

    two = {
      name               = format("%s-%s", "${var.prefix}", "${var.eks_resource_names["frontend"]}")
      instance_types     = var.frontend_instances
      security_group_ids = ["${var.frontend_sg}"]

      min_size     = var.frontend_min
      max_size     = var.frontend_max
      desired_size = var.frontend_desired
    }
  }
}

# data "aws_eks_node_group" "node_group_one" {
#   cluster_name    = module.eks.cluster_id
#   node_group_name = module.eks.eks_managed_node_groups["one"].name
# }

# data "aws_eks_node_group" "node_group_two" {
#   cluster_name    = module.eks.cluster_id
#   node_group_name = module.eks.eks_managed_node_groups["two"].name
# }

