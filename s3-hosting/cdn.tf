module "cdn" {
  source  = "terraform-aws-modules/cloudfront/aws"
  version = "~> 3.0"

  aliases = ["veryuniquesite.com", "www.veryuniquesite.com"]


  comment             = "Cloudfront distribution for www.veryuniquesite.com"
  enabled             = true
  is_ipv6_enabled     = true
  price_class         = "PriceClass_100"
  retain_on_delete    = false
  wait_for_deployment = false
  http_version        = "http2and3"
  default_root_object = "index.html"

  create_origin_access_control = true
  origin_access_control = {
    s3_oac = {
      description      = "Origin Access Control for www.veryuniquesite.com"
      origin_type      = "s3"
      signing_behavior = "always"
      signing_protocol = "sigv4"
    }
  }

  origin {

    s3_oac = {
      domain_name           = "veryuniquesite.s3.amazonaws.com"
      origin_access_control = "s3_oac" # key in `origin_access_control`
    }

  }

  default_cache_behavior = {
    target_origin_id       = "s3_oac"
    viewer_protocol_policy = "redirect-to-https"

    allowed_methods = ["GET", "HEAD", "OPTIONS"]
    cached_methods  = ["GET", "HEAD"]
    compress        = true
    query_string    = true

    # This is id for SecurityHeadersPolicy copied from https://docs.aws.amazon.com/AmazonCloudFront/latest/DeveloperGuide/using-managed-response-headers-policies.html
    response_headers_policy_id = "67f7725c-6f97-4210-82d7-5512b31e9d03"
  }

  viewer_certificate = {
    acm_certificate_arn            = module.acm.acm_certificate_arn
    ssl_support_method             = "sni-only"
    cloudfront_default_certificate = true
    minimum_protocol_version       = "TLSv1.2_2021"
  }

  # optional
  geo_restriction = {
    restriction_type = "blacklist"
    locations        = ["CN", "IR", "KP", "RU"]
  }


}
