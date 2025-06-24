# ECS Role and policy (for containers to access aws)
resource "aws_iam_role" "ecs_task_execution_role" {
  name               = "${var.app_name}-ecs-execution-task-role"
  assume_role_policy = data.aws_iam_policy_document.ecs_task_assume_role.json

  tags = {
    Name = "${var.app_name}-ecs-execution-task-iam-role"
  }
}

data "aws_iam_policy_document" "ecs_task_assume_role" {
  statement {
    actions = ["sts:AssumeRole"]

    principals {
      type        = "Service"
      identifiers = ["ecs-tasks.amazonaws.com"]
    }
  }
}

resource "aws_iam_role_policy_attachment" "ecs_task_execution_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonECSTaskExecutionRolePolicy"
}

data "aws_iam_policy_document" "get_param_secret_policy_document" {
  statement {
    effect = "Allow"
    actions = [
      "secretsmanager:GetSecretValue",
      "ssm:GetParameters"
    ]

     # Warning, audit your secrets for correct access!
    resources = [
      "arn:aws:secretsmanager:${var.aws_region}:${data.aws_caller_identity.current.account_id}:secret:*",
      "arn:aws:ssm:${var.aws_region}:${data.aws_caller_identity.current.account_id}:parameter/*"
    ]
  }
}

resource "aws_iam_policy" "get_param_secret_policy" {
  name        = "get-param-secret-policy"
  description = "Allows getting SSM params and Secret Manager secrets"
  policy      = data.aws_iam_policy_document.get_param_secret_policy_document.json

  tags = {
    Name = "${var.app_name}-ssm-param-secret-policy"
  }
}

resource "aws_iam_role_policy_attachment" "ecs_get_param_secret_policy_attachment" {
  role       = aws_iam_role.ecs_task_execution_role.name
  policy_arn = aws_iam_policy.get_param_secret_policy.arn
}

# EC2 Container role (for EC2 to manage containers)
resource "aws_iam_role" "ec2_container_instance_role" {
  name               = "${var.app_name}-ec2-container-instance-role"
  assume_role_policy = data.aws_iam_policy_document.ec2_container_instance_role_policy.json

  tags = {
    Name = "${var.app_name}-ec2-container-instance-role"
  }
}

resource "aws_iam_role_policy_attachment" "ec2_container_instance_role_policy" {
  role       = aws_iam_role.ec2_container_instance_role.name
  policy_arn = "arn:aws:iam::aws:policy/service-role/AmazonEC2ContainerServiceforEC2Role"
}

resource "aws_iam_instance_profile" "ec2_container_instance_role_profile" {
  name = "${var.app_name}-ec2-container-instance-profile"
  role = aws_iam_role.ec2_container_instance_role.id

  tags = {
    Name = "${var.app_name}-ec2-container-instance-role-profile"
  }
}

data "aws_iam_policy_document" "ec2_container_instance_role_policy" {
  statement {
    actions = ["sts:AssumeRole"]
    effect  = "Allow"

    principals {
      type = "Service"
      identifiers = [
        "ec2.amazonaws.com",
        "ecs.amazonaws.com"
      ]
    }
  }
}


/*
 * TODO create github action policy requirements
 * also add openid connections github<->aws
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "GetAuthorizationToken",
            "Effect": "Allow",
            "Action": [
                "ecr:GetAuthorizationToken"
            ],
            "Resource": "*"
        },
        {
            "Sid": "AllowPushPull",
            "Effect": "Allow",
            "Action": [
                "ecr:BatchGetImage",
                "ecr:BatchCheckLayerAvailability",
                "ecr:CompleteLayerUpload",
                "ecr:GetDownloadUrlForLayer",
                "ecr:InitiateLayerUpload",
                "ecr:PutImage",
                "ecr:UploadLayerPart"
            ],
            "Resource": "arn:aws:ecr:us-east-2:<account_id>:repository/*"
        },
        {
            "Sid": "TaskDefinition",
            "Effect": "Allow",
            "Action": [
                "ecs:RegisterTaskDefinition",
                "ecs:DescribeTaskDefinition"
            ],
            "Resource": "*"
        },
        {
            "Sid": "PassRolesInTaskDefinition",
            "Effect": "Allow",
            "Action": [
                "iam:PassRole"
            ],
            "Resource": [
                "arn:aws:iam::<account_id>:role/demo-ecs-execution-task-role"
            ]
        },
        {
            "Sid": "DeployService",
            "Effect": "Allow",
            "Action": [
                "ecs:UpdateService",
                "ecs:DescribeServices",
                "ecs:RunTask"
            ],
            "Resource": [
                "arn:aws:ecs:us-east-2:<account_id>:service/demo-ecs-cluster/*"
            ]
        }
    ]
}
*/
