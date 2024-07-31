provider "aws" {
  region = "us-east-1"
}

provider "helm" {
  kubernetes {
    config_path = "/root/.kube/config"
  }
}

