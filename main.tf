terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 3.69.0"
    }
  }
}

provider "aws" {
  profile = "default"#this will be a variable
  region  = "us-west-1"#this will be a variable
}

resource "aws_vpc" "main" {
  cidr_block = "129.144.0.0/16"
  tags = {
    "Name" = "MainVPC"
  }
}

resource "aws_subnet" "first" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "129.144.1.0/24"
  availability_zone       = "us-west-1a"#this will be a variable
  map_public_ip_on_launch = "true"
  tags = {
    Name = "FirstSubnet"
  }
}

resource "aws_subnet" "second" {
  vpc_id                  = aws_vpc.main.id
  cidr_block              = "129.144.2.0/24"
  availability_zone       = "us-west-1b"#this will be a variable
  map_public_ip_on_launch = "true"
  tags = {
    Name = "SecondSubnet"
  }
}

resource "aws_internet_gateway" "AAigw" {
  vpc_id = aws_vpc.main.id
  tags = {
    Name = "AAigw"
  }
}

resource "aws_route_table" "AARouteTable" {
  vpc_id = aws_vpc.main.id
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.AAigw.id
  }

  tags = {
    Name = "AARouteTable"
  }
}

resource "aws_route_table_association" "RT-first" {
  subnet_id      = aws_subnet.first.id
  route_table_id = aws_route_table.AARouteTable.id
}

resource "aws_route_table_association" "RT-second" {
  subnet_id      = aws_subnet.second.id
  route_table_id = aws_route_table.AARouteTable.id
}

resource "aws_security_group" "wide_open" {
  vpc_id = aws_vpc.main.id
  ingress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  
  tags = {
    Name = "WideOpen"
  }
}

resource "aws_launch_template" "BasicLaunchTemplate" {
  name_prefix            = "AAChallenge-"
  image_id               = "ami-03af6a70ccd8cb578"
  instance_type          = "t2.micro"
  key_name               = "AAChallenge" #this will be a variable
  vpc_security_group_ids = [aws_security_group.wide_open.id]
  user_data = filebase64("usrdta.sh")
  tag_specifications {
    resource_type = "instance"
    tags = {
      class = "ChatServer"
    }
  }
  tags = {
    Name = "BasicLaunchTemplate"
  }
}

data "aws_subnet_ids" "MainVPCsubnets" {
  vpc_id = aws_vpc.main.id
  depends_on = [
    aws_subnet.first,
    aws_subnet.second
  ]
}

resource "aws_autoscaling_group" "ASG" {
  max_size            = 2
  min_size            = 2
  name                = "MainASG"
  vpc_zone_identifier = data.aws_subnet_ids.MainVPCsubnets.ids
  target_group_arns = [ aws_lb_target_group.LBTGQlero.arn ]
  launch_template {
    id      = aws_launch_template.BasicLaunchTemplate.id
    version = "$Latest"
  }
}

resource "aws_lb" "AAapplb" {
  load_balancer_type = "application"
  subnets            = data.aws_subnet_ids.MainVPCsubnets.ids
  security_groups = [aws_security_group.wide_open.id]
  
  tags = {
    Name = "AAAppLB"
  }
}

resource "aws_lb_target_group" "LBTGQlero" {
  name = "ALBTG"
  port = 80
  protocol = "HTTP"
  vpc_id = aws_vpc.main.id
}

resource "aws_lb_listener" "HTTPlistener" {
  load_balancer_arn = aws_lb.AAapplb.arn
  port = "80"
  protocol = "HTTP"
  default_action {
    type = "forward"
    target_group_arn = aws_lb_target_group.LBTGQlero.arn
  }
}
