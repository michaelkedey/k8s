output "bucket_name" {
  value = aws_s3_bucket.helm_repo_bucket.bucket
}

output "bucket_arn" {
  value = aws_s3_bucket.helm_repo_bucket.arn
}

output "bucket_domain_name" {
  value = aws_s3_bucket.helm_repo_bucket.bucket_regional_domain_name
}

output "bucket_id" {
  value = aws_s3_bucket.helm_repo_bucket.id
}

output "bucket_url" {
  value = aws_s3_bucket.helm_repo_bucket.website_endpoint
}

