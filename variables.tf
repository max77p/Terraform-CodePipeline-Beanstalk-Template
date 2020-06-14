variable "aws_region" {}
variable "aws_profile" {}
variable bucket_name {}
variable "force_destroy" {
  type        = bool
  default     = false
  description = "Force destroy the CI/CD S3 bucket even if it's not empty"
}
variable "app" {
  default = "terraform-codepipeline-example"
}
variable "VPCId" {}
variable "public_subnet" {}
variable "public_subnet2" {}
variable "instance_type" {}
variable "secrets_manager" {}
variable "OAuthToken" {}
variable "Repo" {}
variable "RepoOwner" {}
