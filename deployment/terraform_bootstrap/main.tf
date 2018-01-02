provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "kube_cluster_store" {
  bucket = "pypi-popular-k8s-state-store"
}
