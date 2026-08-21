module "vpc" {
  source = "../module/vpc"
  cidr = var.cidr
  vpc_name = var.vpc_name
  region = var.region
  private_subnet = var.private_subnet
  project_name = var.project_name
  public_subnet = var.public_subnet
}

module "ec2" {
  source = "../module/ec2"
  vpc_name = var.vpc_name
  public_subnet = module.vpc.public_subnet
  project_name = var.project_name
  security_group = module.vpc.sg-ec2
}