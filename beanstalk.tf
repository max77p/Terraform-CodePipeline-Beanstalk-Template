resource "aws_iam_instance_profile" "si-instance-profile-v1" {
  name = "si-instance-profile-v1"
  role = "${aws_iam_role.si-ec2-role-v1.name}"
}

resource "aws_elastic_beanstalk_application" "si-beanstalk" {
  name        = "si-beanstalk-app"
  description = "beanstalk for cicd"

  appversion_lifecycle {
    service_role          = "${aws_iam_role.si-beanstalk-role.arn}"
    max_count             = 100
    delete_source_from_s3 = true
  }
}

resource "aws_elastic_beanstalk_environment" "si-beanstalk-environment" {
  name                = "si-beanstalk-env"
  application         = "${aws_elastic_beanstalk_application.si-beanstalk.name}"
  solution_stack_name = "64bit Amazon Linux 2 v5.0.2 running Node.js 12"

  #--- Configure the VPC, instance and subnet info ---
  setting {
    namespace = "aws:ec2:instances"
    name      = "InstanceTypes"
    value     = "${var.instance_type}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "VPCId"
    value     = "${var.VPCId}"
  }

  setting {
    namespace = "aws:ec2:vpc"
    name      = "Subnets"
    value     = "${var.public_subnet},${var.public_subnet2}"
  }
  setting {
    namespace = "aws:ec2:vpc"
    name      = "ELBSubnets"
    value     = "${var.public_subnet},${var.public_subnet2}"
  }

  #--- Configure environment variables if any ---
  setting {
    namespace = "aws:elasticbeanstalk:application:environment"
    name      = "testVariable"
    value     = "1234"
  }

  #--- Configure your environment ---
  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "EnvironmentType"
    value     = "LoadBalanced"
  }

  setting {
    namespace = "aws:elasticbeanstalk:environment"
    name      = "LoadBalancerType"
    value     = "application"
  }

  #--- Configure launch configuration ---
  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "EC2KeyName"
    value     = "testingpair"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "InstanceType"
    value     = "t2.small"
  }

  setting {
    namespace = "aws:autoscaling:launchconfiguration"
    name      = "IamInstanceProfile"
    value     = "${aws_iam_instance_profile.si-instance-profile-v1.name}"
  }

  #--- Configure your environment's default process. ---

  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Port"
    value     = "80"
  }
  setting {
    namespace = "aws:elasticbeanstalk:environment:process:default"
    name      = "Protocol"
    value     = "HTTP"
  }

  #--- Default listener on port 80 for application load balancer --- 
  setting {
    namespace = "aws:elbv2:listener:default"
    name      = "Protocol"
    value     = "HTTP"
  }

  #--- Autoscaling settings ---
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "Availability Zones"
    value     = "Any"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MinSize"
    value     = "1"
  }
  setting {
    namespace = "aws:autoscaling:asg"
    name      = "MaxSize"
    value     = "2"
  }

}
