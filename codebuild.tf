resource "aws_codebuild_project" "si-codebuild" {
  name          = "RCC-covid-rent-collector-FRONT-END"
  description   = "test-cicd-project"
  build_timeout = "5"
  service_role  = "${aws_iam_role.si-codebuild-role.arn}"

  cache {
    type     = "S3"
    location = "${aws_s3_bucket.si_bucket.bucket}"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "aws/codebuild/standard:1.0"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = "log-group"
      stream_name = "log-stream"
    }

    s3_logs {
      status   = "ENABLED"
      location = "${aws_s3_bucket.si_bucket.id}/build-log"
    }
  }

  source {
    type      = "CODEPIPELINE"
    buildspec = "buildspec.yml"
  }

  artifacts {
    type = "CODEPIPELINE"
  }

}
