provider "aws" {
  region  = "${var.aws_region}"
  profile = "${var.aws_profile}"
}

resource "aws_s3_bucket" "si_bucket" {
  bucket        = "${var.bucket_name}"
  acl           = "private"
  force_destroy = true
}



data "aws_kms_alias" "s3kmskey" {
  name = "alias/aws/s3"
}

resource "aws_codepipeline" "si-codepipeline" {
  name     = "test-pipeline-project"
  role_arn = "${aws_iam_role.si-codepipeline-role.arn}"

  artifact_store {
    location = "${aws_s3_bucket.si_bucket.bucket}"
    type     = "S3"

    # encryption_key {
    #   id   = "data.aws_kms_alias.s3kmskey.arn"
    #   type = "KMS"
    # }
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "ThirdParty"
      provider         = "GitHub"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        Owner                = "${var.RepoOwner}"
        Repo                 = "${var.Repo}"
        OAuthToken           = "${var.OAuthToken}"
        PollForSourceChanges = "true"
        Branch               = "beta"
      }
    }
  }

  stage {
    name = "Build"

    action {
      name             = "Build"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["build_output"]
      version          = "1"

      configuration = {
        ProjectName = "${aws_codebuild_project.si-codebuild.name}"
      }
    }
  }

  stage {
    name = "Deploy"

    action {
      name            = "Deploy"
      category        = "Deploy"
      owner           = "AWS"
      provider        = "ElasticBeanstalk"
      input_artifacts = ["build_output"]
      version         = "1"

      configuration = {
        ApplicationName = "${aws_elastic_beanstalk_application.si-beanstalk.name}"
        EnvironmentName = "${aws_elastic_beanstalk_environment.si-beanstalk-environment.name}"
      }
    }
  }
}
