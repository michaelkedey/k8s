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

resource "aws_s3_bucket_public_access_block" "allow_public_access" {
  bucket                  = aws_s3_bucket.helm_repo_bucket.id
  block_public_acls       = var.disable
  block_public_policy     = var.disable
  ignore_public_acls      = var.disable
  restrict_public_buckets = var.disable
}

#bucket acl
resource "aws_s3_bucket_acl" "s3_bucket_acl" {
  bucket     = aws_s3_bucket.helm_repo_bucket.id
  acl        = var.acl
  depends_on = [aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership]
}

resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.helm_repo_bucket.id
  rule {
    object_ownership = var.s3_ownership
  }
  depends_on = [aws_s3_bucket_public_access_block.allow_public_access]
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

data "aws_s3_bucket" "logs_bucket" {
  bucket = var.logs_bucket
}

resource "aws_cloudtrail" "helm_repo_cloudtrail" {
  name                          = format("%s-%s", "${var.prefix}", "${var.cloudtrail_name}")
  s3_bucket_name                = data.aws_s3_bucket.logs_bucket.bucket
  include_global_service_events = var.enable
}

resource "aws_s3_bucket_logging" "helm_repo_logging" {
  bucket        = data.aws_s3_bucket.logs_bucket.id
  target_bucket = var.logs_bucket
  target_prefix = var.logs_prefix
}

resource "aws_s3_bucket_policy" "helm_repo_bucket_policy" {
  bucket = aws_s3_bucket.helm_repo_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Principal = "*"
        Action = [
          "s3:*",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.helm_repo_bucket.arn}",
          "${aws_s3_bucket.helm_repo_bucket.arn}/*"
        ]
      },
      {
        Sid       = "PublicReadGetObject"
        Principal = "*"
        Action = [
          "s3:GetObject",
        ]
        Effect = "Allow"
        Resource = [
          "${aws_s3_bucket.helm_repo_bucket.arn}",
          "${aws_s3_bucket.helm_repo_bucket.arn}/*"
        ]
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.allow_public_access]
}

resource "aws_s3_bucket_policy" "cloudtrail_bucket_policy" {
  bucket = var.logs_bucket

  policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Service = "cloudtrail.amazonaws.com"
        },
        Action = [
          "s3:GetBucketAcl",
          "s3:PutBucketAcl",
          "s3:PutObject"
        ],
        Resource = [
          "${data.aws_s3_bucket.logs_bucket.arn}",
          "${data.aws_s3_bucket.logs_bucket.arn}/*"
        ]
      }
    ]
  })
}

















