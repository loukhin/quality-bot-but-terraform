module "s3_bucket"{
  source = "./modules/ProjectS3"

  bucket_name = var.bucket_name
  pName       = var.pName
}