module "acm" {
  source  = "terraform-aws-modules/acm/aws"
  version = "~> 5.0"
  providers = {
    aws = aws.us-east-1
  }

  domain_name               = "veryuniquesite.com"
  zone_id                   = data.aws_route53_zone.this.id #DNS
  subject_alternative_names = ["*.veryuniquesite.com"]
  validation_method         = "DNS"
}
