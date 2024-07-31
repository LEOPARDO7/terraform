module "eks" {
  source  = "terraform-aws-modules/eks/aws"
  version = "~> 20.0"

  cluster_name    = "my-cluster"
  cluster_version = "1.30"

  cluster_endpoint_public_access  = true

  cluster_addons = {
    coredns                = {}
    eks-pod-identity-agent = {}
    kube-proxy             = {}
    vpc-cni                = {}
  }

  vpc_id                   = "vpc-08ea02a83fc2e118a"
  subnet_ids               = ["subnet-0d858c7b3b39e7f76", "subnet-081306878eaefbc7d"]
  control_plane_subnet_ids = ["subnet-0d858c7b3b39e7f76", "subnet-081306878eaefbc7d"]
  #security_group_ids       = ["sg-0f1158175af4fdc7f"]
  # EKS Managed Node Group(s)
  eks_managed_node_group_defaults = {
    instance_types = ["m6i.large", "m5.large", "m5n.large", "m5zn.large"]
  }

  eks_managed_node_groups = {
    example = {
      # Starting on 1.30, AL2023 is the default AMI type for EKS managed node groups
      ami_type       = "AL2023_x86_64_STANDARD"
      instance_types = ["m5.xlarge"]

      min_size     = 2
      max_size     = 3
      desired_size = 2
    }
  }

  # Cluster access entry
  # To add the current caller identity as an administrator
  enable_cluster_creator_admin_permissions = true


  tags = {
    Environment = "dev"
    Terraform   = "true"
  }
}

resource "helm_release" "helm" {
  name      = "my-release"
  chart     = "/root/terraform/Charts"
  namespace = "default"
}
