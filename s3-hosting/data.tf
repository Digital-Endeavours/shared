data "aws_route53_zone" "this" {
  name = "veryuniquesite.com"
}

# This assumes your key already exists
data "aws_kms_key" "s3" {
  key_id = "alias/s3_key"
}

data "aws_iam_policy_document" "s3_policy" {
  # IAM Role Access
  statement {
    sid    = "Access"
    effect = "Allow"

    actions = [
      "s3:ListBucket",
      "s3:GetObject",
      "s3:Put*",
      "s3:List*",
    ]
    resources = [
      module.s3.s3_bucket_arn,
      "${module.s3.s3_bucket_arn}/*",
    ]

    principals {
      type = "AWS"
      identifiers = [
        "${ci-role-full-arn}" #replace with the arn or variable of it.
      ]
    }

  }

  # Origin Access Controls
  statement {
    actions   = ["s3:GetObject"]
    resources = ["${module.s3.s3_bucket_arn}/*"]

    principals {
      type        = "Service"
      identifiers = ["cloudfront.amazonaws.com"]
    }

    condition {
      test     = "StringEquals"
      variable = "aws:SourceArn"
      values   = [module.cdn.cloudfront_distribution_arn]
    }
  }

}
