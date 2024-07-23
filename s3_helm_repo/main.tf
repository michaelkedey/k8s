module "help_repo_bucket" {
  source      = "./modules/repo"
  logs_bucket = var.logs_bucket #"./env/.terraform.tfvars"
  #file_path   = "var.file_path"
}

module "helm_repo_files" {
  source    = "./modules/repo_files"
  bucket    = module.help_repo_bucket.bucket_name
  bucket_id = module.help_repo_bucket.bucket_id
}
