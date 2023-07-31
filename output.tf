output "vpc_id" {
  description = "ID of the created VPC"
  value       = module.vpc.vpc_id
}

output "public_subnet_az1" {
  description = "IDs of the created public subnets"
  value       = module.vpc.public_subnet_az1_id
}

output "public_subnet_az2" {
  description = "IDs of the created public subnets"
  value       = module.vpc.public_subnet_az2_id
}


output "private_subnet_az1" {
  description = "IDs of the created public subnets"
  value       = module.vpc.private_subnet_az1_id
}

output "private_subnet_az2" {
  description = "IDs of the created public subnets"
  value       = module.vpc.private_subnet_az2_id
}

/* output "public_subnet_az1" {
  description = "IDs of the created public subnets"
  value       = module.vpc.public_subnet_ids
}

output "public_subnet_az1" {
  description = "IDs of the created public subnets"
  value       = module.vpc.public_subnet_ids
} */