
module "rds-mssql" {
  source            = "jameswoolfenden/rds/aws"
  version           = "0.1.4"
  common_tags       = var.common_tags
  instance          = var.instance
  instance_password = "Password123"
  storage_encrypted = false
  subnet_group      = var.subnet_group
  subnet_ids        = var.subnet_ids
}
