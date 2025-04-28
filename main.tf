provider "aws" {
  region = var.aws_region
}

# Reference the existing IAM role for ECS task execution
resource "aws_ecs_task_definition" "app_task" {
  family                   = var.ecs_task_config.family
  container_definitions    = jsonencode([
    {
      name      = var.ecs_task_config.container_name
      image     = var.container_image
      memory    = tonumber(var.ecs_task_config.memory)
      cpu       = tonumber(var.ecs_task_config.cpu)
      essential = true
      portMappings = [
        {
          containerPort = var.ecs_task_config.container_port
          hostPort      = var.ecs_task_config.host_port
          protocol      = "tcp"
        }
      ],
      environment = [
        for key, value in var.environment_variables : {
          name  = key
          value = value
        }
      ],
      logConfiguration = {
        logDriver = "awslogs"
        options = {
          awslogs-group         = "/ecs/flask-api"
          awslogs-region        = var.aws_region
          awslogs-stream-prefix = "ecs"
        }
      }
    }
  ])
  requires_compatibilities = ["FARGATE"]
  network_mode             = "awsvpc"
  memory                   = var.ecs_task_config.memory
  cpu                      = var.ecs_task_config.cpu
  execution_role_arn       = var.ecs_task_config.execution_role
  task_role_arn            = var.ecs_task_config.task_role
}

resource "aws_ecs_service" "flask_api_service" {
  name            = var.ecs_service_config.name
  cluster         = data.aws_ecs_cluster.app_cluster.arn
  task_definition = aws_ecs_task_definition.app_task.arn
  desired_count   = var.ecs_service_config.desired_count
  launch_type     = "FARGATE"

  network_configuration {
    subnets         = data.aws_subnets.selected.ids 
    security_groups = [data.aws_security_group.sqsgroup.id, data.aws_security_group.default.id]
    assign_public_ip = true
  }

  load_balancer {
    target_group_arn = var.ecs_service_config.target_group_arn
    container_name   = var.ecs_task_config.container_name
    container_port   = var.ecs_task_config.container_port
  }
}
