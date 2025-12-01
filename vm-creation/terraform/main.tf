locals {
  prefix = "mig"
}

# Deploy the migration environment
module "migration_environment" {
  source = "./modules/environment"
  
  prefix         = local.prefix
  environment    = "mm1"
  location       = var.location
  vm_size        = var.hostvmsize
  admin_username = "adminuser"
  admin_password = var.vmpassword
  
  artifacts_location = var.artifacts_location
}

module "mm3" {
  source = "./modules/environment"
  
  prefix         = local.prefix
  environment    = "mm3"
  location       = var.location
  vm_size        = var.hostvmsize
  admin_username = "adminuser"
  admin_password = var.vmpassword
  
  artifacts_location = var.artifacts_location
}