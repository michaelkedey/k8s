#upload objects
resource "aws_s3_object" "files" {
  for_each = fileset("${path.module}/${var.path}", "**/*.*")

  bucket       = var.bucket_id
  key          = each.value
  source       = "${path.module}/${var.path}"
  etag         = filemd5("${path.module}/${var.path}/${each.value}")
  content_type = lookup({
    ".yaml" = "application/yaml"
    ".yml"  = "application/yaml"
    ".tgz"  = "application/gzip"
  }, (each.value), "application/octet-stream")
 #default for unknown typeseach.value

  depends_on = [
    var.bucket
  ]

}