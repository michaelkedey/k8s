#bucket
resource "aws_s3_bucket" "helm_repo_bucket" {
  bucket = format("%s-%s", "${var.prefix}", "${var.bucket_name}")
  tags = merge(
    var.tags_all,
    {
      Name = format("%s-%s", "${var.prefix}", "${var.bucket_name}")
    }
  )
}

resource "aws_s3_bucket_versioning" "helm_repo_bucket_versioning" {
  versioning_configuration {
    status = var.version_status
  }
  bucket = aws_s3_bucket.helm_repo_bucket.bucket
}

# Configure bucket policy for public read access to objects
data "aws_iam_policy_document" "helm_repo_policy" {
  statement {
    actions   = ["s3:GetObject"]
    resources = [aws_s3_bucket.helm_repo_bucket.arn, "${aws_s3_bucket.helm_repo_bucket.arn}/*"]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
}

data "aws_iam_policy_document" "helm_repo_policy2" {
  version = "2012-10-17"

  statement {
    effect = "Allow"
    actions = ["s3:PutBucketPolicy"]
    resources = [
      "${aws_s3_bucket.helm_repo_bucket.name}" 
    ]
  }
}

resource "aws_s3_bucket_policy" "helm_repo_bucket_policy" {
  bucket = aws_s3_bucket.helm_repo_bucket.id
  policy = data.aws_iam_policy_document.helm_repo_policy.json
}

# Create an IAM policy and attach it to a user, role, or group
resource "aws_iam_policy" "example_policy" {
  name        = "ExamplePolicy"
  description = "Allows PutBucketPolicy action on my S3 bucket"

  policy = data.aws_iam_policy_document.example_policy.json
}

# Attach the policy to an IAM user, role, or group
resource "aws_iam_policy_attachment" "example_attachment" {
  name       = "ExampleAttachment"
  roles      = ["your-role-name"]  # Replace with the name of your IAM role
  policy_arn = aws_iam_policy.example_policy.arn
}

resource "aws_s3_object" "index_dot_yaml_file" {
  for_each = fileset(var.file_path, "**/*")

  bucket = aws_s3_bucket.helm_repo_bucket.id
  key    = each.value
  source = "${var.file_path}/${each.value}"
  etag   = filebase64("${var.file_path}/${each.value}")
  content_type = lookup({
    ".yaml" = "text/yml"
  }, each.value, "application/octet-stream") # default for unknown types

  depends_on = [
    aws_s3_bucket.helm_repo_bucket
  ]
}


#configure static server
resource "aws_s3_bucket_website_configuration" "static-website" {
  bucket = aws_s3_bucket.helm_repo_bucket.id

  index_document {
    suffix = var.suffix
  }

  # error_document {
  #   key = var.error
  # }
}

resource "aws_cloudtrail" "helm_repo_cloudtrail" {
  name                          = format("%s-%s", "${var.prefix}", "${var.cloudtrail_name}")
  s3_bucket_name                = aws_s3_bucket.helm_repo_bucket.id
  include_global_service_events = var.enable
}

resource "aws_s3_bucket_logging" "helm_repo_logging" {
  bucket        = aws_s3_bucket.helm_repo_bucket.id
  target_bucket = var.logs_bucket
  target_prefix = var.logs_prefix
}

# #bucket acl
# resource "aws_s3_bucket_acl" "s3_bucket_acl" {
#   bucket = aws_s3_bucket.bid_bucket.id
#   acl    = var.acl
# }
















