variable "ec2_security_group_id" {} 

resource "aws_db_subnet_group" "mysql_subnet_group" {
  name       = "db-subnet"
  subnet_ids = [var.private_subnet_az1_id,var.private_subnet_az2_id]
}


resource "aws_db_instance" "source_rds_instance" {

  
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  identifier           = "my-source-rds"
  db_name                 = "mydb"
  username             = "admin"
  password             = "mypassword"
  db_subnet_group_name  = aws_db_subnet_group.mysql_subnet_group.name
  multi_az              = true  # Enable Multi-AZ deployment
  backup_retention_period = 7   # Optional: Set the backup retention period
  vpc_security_group_ids = [
    # Specify the security group(s) for RDS here, e.g., "sg-12345678"
    aws_security_group.rds_sg.id,
  ]

  tags = {
    Name = "MySourceRDSInstance"
  }
}

resource "aws_db_instance" "read_replica_rds_instance" {
  engine               = "mysql"
  instance_class       = "db.t2.micro"
  allocated_storage    = 20
  identifier           = "my-read-replica-rds"
  #db_name                 = "mydbreplica"
  #username             = "admin"
  password             = "mypassword"
  db_subnet_group_name  = aws_db_subnet_group.mysql_subnet_group.name
  multi_az              = true  # Enable Multi-AZ deployment
  backup_retention_period = 7   # Optional: Set the backup retention period
  vpc_security_group_ids = [
    # Specify the security group(s) for RDS here, e.g., "sg-12345678"
    aws_security_group.rds_sg.id,
  ]
  replicate_source_db = aws_db_instance.source_rds_instance.arn 
  # ARN of the source RDS instance
  tags = {
    Name = "MyReadReplicaRDSInstance"
  }
}

resource "aws_security_group" "rds_sg" {
  name_prefix = "rds-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"

    # Specify the security group ID of the EC2 instance here, e.g., "sg-98765432"
    security_groups = [
      var.ec2_security_group_id
    ]
  }
}


