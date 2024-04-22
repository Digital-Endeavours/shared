module "s3" {
  source  = "terraform-aws-modules/s3-bucket/aws"
  version = "~> 3.15.1"

  bucket                   = "veryuniquesite"
  force_destroy            = true
  control_object_ownership = true
  object_ownership         = "ObjectWriter"
  attach_policy            = true
  policy                   = data.aws_iam_policy_document.s3_policy.json
  allowed_kms_key_arn      = data.aws_kms_key.s3.arn

  versioning = {
    status     = true
    mfa_delete = false
  }

  website = {
    index_document = "index.html"

    server_side_encryption_configuration = {
      rule = {
        apply_server_side_encryption_by_default = {
          kms_master_key_id = data.aws_kms_key.s3.arn
          sse_algorithm     = "aws:kms"
        }
      }
    }
  }
}
