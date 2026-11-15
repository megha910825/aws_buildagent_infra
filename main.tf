module "vpc" {
  source = "./modules/vpc"
}
module "security_group" {
  source = "./modules/security-group"
  ba_vpc_id = module.vpc.ba_vpc_id
}
module "iam" {
  source = "./modules/iam"
}
module "ec2" {
  source = "./modules/ec2"

  subnet_id            = module.vpc.ba_subnet_private_id
  security_group_id    = module.security_group.ba_sg_id
  instance_profile_name = module.iam.instance_profile_name
}
