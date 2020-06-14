#------ CODEPIPELINE ROLE ------
resource "aws_iam_role" "si-codepipeline-role" {
  name = "si-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#------ CODEBUILD ROLE ------
resource "aws_iam_role" "si-codebuild-role" {
  name = "si-codebuild-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

#------ BEANSTALK ROLE ------
resource "aws_iam_role" "si-beanstalk-role" {
  name = "si-beanstalk-role"


  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
          "Service": "elasticbeanstalk.amazonaws.com"
      },
      "Action":"sts:AssumeRole"
    }
  ]
}
EOF
}

#------ EC2 ROLE ------
resource "aws_iam_role" "si-ec2-role-v1" {
  name = "si-ec2-role-v1"

  assume_role_policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "sts:AssumeRole",
            "Principal": {
               "Service": "ec2.amazonaws.com"
            },
            "Effect": "Allow"
        }
    ]
}
EOF
}

#----------------------------------------------------- POLICY SECTION -----------------------------------------------------

#------ CODEPIPELINE ROLE POLICY ------
resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "si-codepipeline-policy"
  role = "${aws_iam_role.si-codepipeline-role.id}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.si_bucket.arn}",
        "${aws_s3_bucket.si_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": ["*"],
      "Resource": "*"
    }
  ]
}
EOF
}


data "aws_secretsmanager_secret" "si-arn" {
  arn = "${var.secrets_manager}"
}

#------ CODEBUILD ROLE POLICY ------
resource "aws_iam_role_policy" "si-codebuild-policy" {
  name = "si-codebuild-policy"
  role = "${aws_iam_role.si-codebuild-role.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [
        "*"
      ],
      "Action": [
        "logs:CreateLogGroup",
        "logs:CreateLogStream",
        "logs:PutLogEvents"
      ]
    },
    {
      "Effect": "Allow",
      "Action": [
        "s3:GetObject",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.si_bucket.arn}",
        "${aws_s3_bucket.si_bucket.arn}/*"
      ]
    },
    {
      "Effect": "Allow",
      "Action": "secretsmanager:GetSecretValue",
      "Resource": "${data.aws_secretsmanager_secret.si-arn.arn}"
    }
  ]
}
EOF
}

#------ BEANSTALK INSTANCE PROFILE ROLE POLICY ------
resource "aws_iam_role_policy" "si-beanstalk-policy" {
  name = "si-codebuild-policy"
  role = "${aws_iam_role.si-beanstalk-role.name}"

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": "*",
      "Action": "*"
    }
  ]
}
EOF
}
