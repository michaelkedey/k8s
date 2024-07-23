# resource "aws_s3_object" "repo_files" {
#   for_each = fileset(var.file_path, "**/*")

#   bucket = aws_s3_bucket.helm_repo_bucket.id
#   key    = each.value
#   source = "${var.file_path}/${each.value}"
#   etag   = filebase64("${var.file_path}/${each.value}")
#   content_type = lookup({
#     ".yaml"  = "text/yaml",
#     ".tgz"  = "application/x-compressed-tar",
#   }, each.value, "application/octet-stream") #default for unknown types

#   depends_on = [
#     aws_s3_bucket.helm_repo_bucket
#   ]
# }
locals {
  repo_files_filepath = "../../uploads"
}

resource "aws_s3_object" "repo_files" {
  for_each = fileset(local.repo_files_filepath, "**")
  bucket   = var.bucket_id #aws_s3_bucket.helm_repo_bucket.id
  key      = each.key
  source   = "${local.repo_files_filepath}/${each.value}"
  etag     = filemd5("${local.repo_files_filepath}/${each.value}")

  depends_on = [
    var.bucket #aws_s3_bucket.helm_repo_bucket
  ]
}