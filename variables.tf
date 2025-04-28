# AWS Region configuration
variable "aws_region" {
  description = "AWS region to deploy resources"
  type        = string
  default     = "us-east-1"
}

# Availability Zones configuration
variable "availability_zones" {
  description = "List of availability zones to use"
  type        = list(string)
  default     = []
}

# Security groups configuration
variable "security_group_names" {
  description = "Names of security groups to use"
  type        = map(string)
  default     = {}
}

# ECS configuration
variable "ecs_cluster_name" {
  description = "Name of the ECS cluster"
  type        = string
  default     = ""
}

variable "ecs_task_config" {
  description = "Configuration for ECS task"
  type        = object({
    family           = string
    memory           = string
    cpu              = string
    container_name   = string
    container_port   = number
    host_port        = number
    execution_role   = string
    task_role        = string
  })
  default     = {
    family           = ""
    memory           = ""
    cpu              = ""
    container_name   = ""
    container_port   = 0
    host_port        = 0
    execution_role   = ""
    task_role        = ""
  }
}

# Container image configuration
variable "container_image" {
  description = "ECR repository URL for container image"
  type        = string
  default     = ""
}

# Environment variables
variable "environment_variables" {
  description = "Environment variables for the container"
  type        = map(string)
  default     = {}
}

# Service configuration
variable "ecs_service_config" {
  description = "Configuration for ECS service"
  type        = object({
    name            = string
    desired_count   = number
    target_group_arn = string
  })
  default     = {
    name            = ""
    desired_count   = 1
    target_group_arn = ""
  }
}