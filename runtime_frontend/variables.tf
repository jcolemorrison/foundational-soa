variable "aws_default_region" {
  type        = string
  description = "The default region that all resources will be deployed into."
  default     = "us-east-1"
}

variable "aws_default_tags" {
  type        = map(string)
  description = "Default tags added to all AWS resources."
  default = {
    Project = "foundational-soa-runtime-frontend"
  }
}

variable "subdomain_name" {
  type = string
  description = "full sub domain name of the frontend application, also used as the s3 bucket name. i.e. app.hashidemo.com"
}

variable "cloudfront_price_class" {
  type = string
  description = "Price class of cloudfront distribution.  This determines how many locations its deployed to."
  default = "PriceClass_All"
}