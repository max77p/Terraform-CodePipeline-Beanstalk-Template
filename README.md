# AWS CodePipeline to automate development - Template by Shan

### Github -> CodePipeline -> Beanstalk - HTTP only
1. Replace example.tfvars with terraform.tfvars and complete all the variables
2. If your buildspec.yml file is pulling secrets from secret manager, make sure to put the arn of the secrets manager in tfvars file
3. Policies are generic and should be fine tuned for security
4. Configure settings for HTTPS

* Terraform init
* Terraform plan
* Terraform apply
