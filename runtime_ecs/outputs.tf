output "default_region" {
  value = data.aws_region.current
  description = "default region of deployment in AWS"
}