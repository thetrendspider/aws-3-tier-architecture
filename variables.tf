variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "public_subnet_cidrs" {
  description = "List of CIDR blocks for the public subnets"
  type        = list(string)
  default     = ["10.0.1.0/24", "10.0.2.0/24"]
}

variable "private_subnet_cidrs" {
  description = "List of CIDR blocks for the private subnets"
  type        = list(string)
  default     = ["10.0.3.0/24", "10.0.4.0/24"]
}

variable "availability_zones" {
  description = "List of availability zones for the subnets"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "ec2_instance_type" {
  description = "EC2 instance type for the instances in private subnets"
  type        = string
  default     = "t2.micro"
}

variable "rds_instance_class" {
  description = "RDS instance class for the RDS instances"
  type        = string
  default     = "db.t2.micro"
}

variable "alb_listener_port" {
  description = "The port on which the ALB should listen"
  type        = number
  default     = 80
}
