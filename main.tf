provider "aws" {
  region = "us-east-1"  # Replace with your desired AWS region
}

module "vpc" {
  source = "./modules/vpc"
  vpc_id              = module.vpc.vpc_id
  private_subnet_az1_id      = module.vpc.private_subnet_az1_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id  
  private_subnet_az2_id      = module.vpc.private_subnet_az2_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  

}

module "ec2" {
  source = "./modules/ec2"
  vpc_id              = module.vpc.vpc_id
  private_subnet_az1_id      = module.vpc.private_subnet_az1_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id  
  private_subnet_az2_id      = module.vpc.private_subnet_az2_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  
}

module "rds" {
  source = "./modules/rds"
  vpc_id              = module.vpc.vpc_id
  private_subnet_az1_id      = module.vpc.private_subnet_az1_id
  public_subnet_az1_id       = module.vpc.public_subnet_az1_id  
  private_subnet_az2_id      = module.vpc.private_subnet_az2_id
  public_subnet_az2_id        = module.vpc.public_subnet_az2_id
  #private_subnet_ids  = module.vpc.private_subnet_ids
}  


