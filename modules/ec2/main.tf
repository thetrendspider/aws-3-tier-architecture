x
resource "aws_launch_template" "ec2_public" {
  name_prefix   = "ec2_public"
  image_id      = var.ami_id  # Replace with your desired AMI ID
  instance_type = var.ec2_instance_type
  #subnet_id     = element(var.private_subnet_ids, count.index)

  # Additional configuration for the instance, such as security groups, IAM role, etc.
  vpc_security_group_ids = [
    # Specify the security group(s) for EC2 here, e.g., "sg-12345678"
    aws_security_group.ec2_sg.id,aws_security_group.alb_sg.id
  ]
  user_data              = filebase64("script.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = "poc-instance-public"  # Replace with your desired name for the EC2 instances
      // Add other tags if needed
    }
  }
}





resource "aws_autoscaling_group" "ec2_public" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  launch_template {
    id      = aws_launch_template.ec2_public.id
    version = "$Latest"  # Use the latest version of the launch template
  }

  vpc_zone_identifier = [var.public_subnet_az1_id,var.public_subnet_az2_id]

  # Attaching the Load Balancer to the Auto Scaling Group
  target_group_arns = [aws_lb_target_group.alb_target_group.arn]

  
}

resource "aws_launch_template" "ec2_private" {
  name_prefix   = "ec2_private"
  image_id      = var.ami_id  # Replace with your desired AMI ID
  instance_type = var.ec2_instance_type
  #subnet_id     = element(var.private_subnet_ids, count.index)

  # Additional configuration for the instance, such as security groups, IAM role, etc.
  vpc_security_group_ids = [
    # Specify the security group(s) for EC2 here, e.g., "sg-12345678"
    aws_security_group.ec2_sg.id,aws_security_group.alb_sg.id
  ]
  user_data              = filebase64("script.sh")

  tag_specifications {
    resource_type = "instance"

    tags = {
      "Name" = "poc-instance-private"  # Replace with your desired name for the EC2 instances
      // Add other tags if needed
    }
  }
}





resource "aws_autoscaling_group" "ec2_private" {
  desired_capacity     = 2
  max_size             = 4
  min_size             = 2
  launch_template {
    id      = aws_launch_template.ec2_private.id
    version = "$Latest"  # Use the latest version of the launch template
  }

  vpc_zone_identifier = [var.private_subnet_az1_id,var.private_subnet_az2_id]

  # Attaching the Load Balancer to the Auto Scaling Group
  target_group_arns = [aws_lb_target_group.alb_target_group.arn]

  
}



resource "aws_security_group" "ec2_sg" {
  name_prefix = "ec2-sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = "0"
    to_port     = "0"
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}


resource "aws_security_group" "alb_sg" {
  name_prefix = "alb_sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = var.alb_listener_port
    to_port     = var.alb_listener_port
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

/* resource "aws_security_group" "asg_sg" {
  name_prefix = "asg_sg-"
  vpc_id      = var.vpc_id

  ingress {
    from_port   = 0
    to_port     = 65535
    protocol    = "tcp"
    security_groups = [aws_security_group.alb_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
} */

resource "aws_lb" "alb" {
  name               = "my-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb_sg.id]
  subnets            = [var.public_subnet_az1_id,var.public_subnet_az2_id]
}

resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = var.alb_listener_port
  protocol          = "HTTP"

  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.alb_target_group.arn
  }
}

resource "aws_lb_target_group" "alb_target_group" {
  name        = "my-alb-target-group"
  port        = var.alb_listener_port
  protocol    = "HTTP"
  vpc_id      = var.vpc_id
  target_type = "instance"

  health_check {
    healthy_threshold   = 2
    unhealthy_threshold = 2
    timeout             = 5
    interval            = 10
    path                = "/"
    matcher             = "200-299"
  }
}

output "ec2_security_group_id" {
  value = aws_security_group.ec2_sg.id
}



