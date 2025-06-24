resource "aws_ecs_cluster" "default" {
  name = "${var.app_name}-ecs-cluster"

  setting {
    name  = "containerInsights"
    value = "enabled"
  }

  tags = {
    Name = "${var.app_name}-ecs-cluster"
  }
}

resource "aws_ecs_capacity_provider" "web" {
  name = "${var.app_name}-web-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.web.arn
    managed_termination_protection = "ENABLED"

    # TODO tune for prod, steps are ec2 instances scaled outward/inward
    # currently set for safety
    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }

  tags = {
    Name = "${var.app_name}-ecs-capacity-provider"
  }
}

resource "aws_ecs_capacity_provider" "worker" {
  name = "${var.app_name}-worker-capacity-provider"

  auto_scaling_group_provider {
    auto_scaling_group_arn         = aws_autoscaling_group.worker.arn
    managed_termination_protection = "ENABLED"

    # TODO tune for prod, steps are ec2 instances scaled outward/inward
    # currently set for safety
    managed_scaling {
      maximum_scaling_step_size = 1
      minimum_scaling_step_size = 1
      status                    = "ENABLED"
      target_capacity           = 10
    }
  }

  tags = {
    Name = "${var.app_name}-ecs-capacity-provider"
  }
}

resource "aws_ecs_cluster_capacity_providers" "default" {
  cluster_name = aws_ecs_cluster.default.name

  capacity_providers = [
    aws_ecs_capacity_provider.web.name,
    aws_ecs_capacity_provider.worker.name
  ]
}


resource "aws_ecr_repository" "php_ecr" {
  name         = "${var.app_name}-php-ecr"
  force_delete = true

  tags = {
    Name = "${var.app_name}-php-ecr"
  }
}

resource "aws_ecr_repository" "nginx_ecr" {
  name         = "${var.app_name}-nginx-ecr"
  force_delete = true

  tags = {
    Name = "${var.app_name}-nginx-ecr"
  }
}

resource "aws_ecr_repository" "php_cli_ecr" {
  name         = "${var.app_name}-php-cli-ecr"
  force_delete = true

  tags = {
    Name = "${var.app_name}-php-cli-ecr"
  }
}

# TODO create and set iam role per task def
# TODO consider volume usage
resource "aws_ecs_task_definition" "web" {
  family = "${var.app_name}-web-task"

  # all env vars are pulled in from ssm as "secrets" because
  # the valueFrom property dynamically applies the secret *or* ssm param
  # from the provided arn - view/edit locals in locals.tf
  container_definitions = <<DEFINITION
  [
    {
      "name": "php",
      "image": "${local.aws_ecr_php_url}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 9000,
          "hostPort": 9000
        }
      ],
      "secrets": ${jsonencode(local.secrets)},
      "environment": ${jsonencode(local.web_environment)},
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "${var.app_name}-container-logs",
              "awslogs-region": "${var.aws_region}",
              "awslogs-create-group": "true",
              "awslogs-stream-prefix": "php-fpm"
          }
      }
    },
    {
      "name": "nginx",
      "image": "${local.aws_ecr_nginx_url}:latest",
      "essential": true,
      "portMappings": [
        {
          "containerPort": 80,
          "hostPort": 80
        }
      ],
      "networkMode": "awsvpc",
      "dependsOn": [
        {
          "containerName": "php",
          "condition": "START"
        }
      ],
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "${var.app_name}-container-logs",
              "awslogs-region": "${var.aws_region}",
              "awslogs-create-group": "true",
              "awslogs-stream-prefix": "nginx"
          }
      }
    }
  ]
  DEFINITION

  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  tags = {
    Name = "${var.app_name}-ecs-task-definition"
  }
}

# TODO consider volume usage
# this can probably inherit from the web family
resource "aws_ecs_task_definition" "worker" {
  family = "${var.app_name}-worker-task"

  container_definitions = <<DEFINITION
  [
    {
      "name": "php_cli",
      "image": "${local.aws_ecr_php_cli_url}:latest",
      "essential": true,
      "secrets": ${jsonencode(local.secrets)},
      "environment": ${jsonencode(local.worker_environment)},
      "networkMode": "awsvpc",
      "logConfiguration": {
          "logDriver": "awslogs",
          "options": {
              "awslogs-group": "${var.app_name}-container-logs",
              "awslogs-region": "${var.aws_region}",
              "awslogs-create-group": "true",
              "awslogs-stream-prefix": "php-cli"
          }
      }
    }
  ]
  DEFINITION

  requires_compatibilities = ["EC2"]
  network_mode             = "awsvpc"
  memory                   = "512"
  cpu                      = "256"
  execution_role_arn       = aws_iam_role.ecs_task_execution_role.arn
  task_role_arn            = aws_iam_role.ecs_task_execution_role.arn

  tags = {
    Name = "${var.app_name}-ecs-task-definition"
  }
}

resource "aws_ecs_service" "web_ecs_service" {
  name                 = "${var.app_name}-web-ecs-service"
  cluster              = aws_ecs_cluster.default.id
  task_definition      = "${aws_ecs_task_definition.web.family}:${aws_ecs_task_definition.web.revision}"
  desired_count        = 1
  force_new_deployment = true

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.web.name
    weight            = 100
  }


  network_configuration {
    subnets          = [aws_subnet.private.id, aws_subnet.private2.id]
    assign_public_ip = false
    security_groups = [
      aws_security_group.web_sg.id,
      aws_security_group.alb_sg.id
    ]
  }

  load_balancer {
    target_group_arn = aws_lb_target_group.default.arn
    container_name   = "nginx" # TODO switch to ${var.app_name}-nginx-container
    container_port   = 80
  }

  # TODO
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
  # race condition can exist where policy is lost before ecs can finish
  # we use an auto attached ECS service role, not sure how to define that here
  # depends_on = []

  tags = {
    Name = "${var.app_name}-web-ecs-service"
  }
}

resource "aws_ecs_service" "worker_ecs_service" {
  name                 = "${var.app_name}-worker-ecs-service"
  cluster              = aws_ecs_cluster.default.id
  task_definition      = "${aws_ecs_task_definition.worker.family}:${aws_ecs_task_definition.worker.revision}"
  desired_count        = 1
  force_new_deployment = true

  capacity_provider_strategy {
    capacity_provider = aws_ecs_capacity_provider.worker.name
    weight            = 100
  }

  network_configuration {
    subnets          = [aws_subnet.private.id, aws_subnet.private2.id]
    assign_public_ip = false
    security_groups = [
      aws_security_group.web_sg.id,
      aws_security_group.alb_sg.id
    ]
  }

  # TODO
  # https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/ecs_service
  # race condition can exist where policy is lost before ecs can finish
  # we use an auto attached ECS service role, not sure how to define that here
  # depends_on = []

  tags = {
    Name = "${var.app_name}-worker-ecs-service"
  }
}
