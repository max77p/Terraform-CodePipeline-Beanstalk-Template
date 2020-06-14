# ----------------------------------------------------------------------
# Beanstalk url
# ----------------------------------------------------------------------
output "url" {
  value = "${aws_elastic_beanstalk_environment.si-beanstalk-environment.cname}"
}
