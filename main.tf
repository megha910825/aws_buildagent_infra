module "vpc" {
  source = "./modules/vpc"
}
module "security_group" {
  source = "./modules/security-group"
  ba_vpc_id = module.vpc.ba_vpc_id
}
