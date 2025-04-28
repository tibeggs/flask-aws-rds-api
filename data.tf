# Fetch the default VPC
data "aws_vpc" "default" {
  default = true
}

# Fetch availability zones
data "aws_availability_zones" "available" {
  state = "available"
  filter {
    name   = "zone-name"
    values = var.availability_zones
  }
}

# Fetch the default subnets in the VPC
data "aws_subnets" "default" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
}

# Fetch the subnets in specific availability zones
data "aws_subnets" "selected" {
  filter {
    name   = "vpc-id"
    values = [data.aws_vpc.default.id]
  }
  
  filter {
    name   = "availability-zone"
    values = data.aws_availability_zones.available.names
  }
}

# Fetch the security group by name
data "aws_security_group" "sqsgroup" {
  filter {
    name   = "group-name"
    values = [var.security_group_names.sqs]
  }
}

# Fetch the default security group
data "aws_security_group" "default" {
  vpc_id = data.aws_vpc.default.id
  name   = var.security_group_names.default
}

# Reference the existing ECS cluster
data "aws_ecs_cluster" "app_cluster" {
  cluster_name = var.ecs_cluster_name
}