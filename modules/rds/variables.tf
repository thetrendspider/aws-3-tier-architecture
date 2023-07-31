variable "vpc_id" {
  description = "ID of the VPC"
}

variable "private_subnet_az1_id" {}
variable "private_subnet_az2_id" {}
variable "public_subnet_az1_id" {}
variable "public_subnet_az2_id" {}




variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}



variable "public_subnet_cidrs_az1" {
  description = "List of CIDR blocks for the public subnets"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_cidrs_az2" {
  description = "List of CIDR blocks for the public subnets"
  type        = string
  default     = "10.0.2.0/24"
}

variable "private_subnet_cidrs_az1" {
  description = "List of CIDR blocks for the private subnets"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_cidrs_az2" {
  description = "List of CIDR blocks for the private subnets"
  type        = string
  default     = "10.0.4.0/24"
}
variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}


variable "rds_instance_class" {
  description = "RDS instance class for the RDS instances"
  type        = string
  default     = "db.t2.micro"
}

