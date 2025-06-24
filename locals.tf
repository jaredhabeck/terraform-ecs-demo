# local variables

locals {
  local_tags = {
    Purpose = "POC"
  }
  tags = merge(var.tags, local.local_tags)
}

locals {
  aws_ecr_php_url     = aws_ecr_repository.php_ecr.repository_url
  aws_ecr_nginx_url   = aws_ecr_repository.nginx_ecr.repository_url
  aws_ecr_php_cli_url = aws_ecr_repository.php_cli_ecr.repository_url
  web_environment = [
    {
      Name  = "APP_ENV"
      Value = data.aws_ssm_parameter.APP_ENV.value
    }
  ]
  worker_environment = [
    {
      Name  = "APP_ENV"
      Value = data.aws_ssm_parameter.WORKER_APP_ENV.value
    }
  ]
  secrets = [
    {
      Name      = "APP_NAME"
      ValueFrom = aws_ssm_parameter.APP_NAME.arn
    },
    {
      Name      = "APP_KEY"
      ValueFrom = "${aws_secretsmanager_secret.QA_APP_KEY.arn}:key::"
    },
    {
      Name      = "APP_DEBUG"
      ValueFrom = aws_ssm_parameter.APP_DEBUG.arn
    },
    {
      Name      = "APP_LOG_LEVEL"
      ValueFrom = aws_ssm_parameter.APP_LOG_LEVEL.arn
    },
    {
      Name      = "APP_URL"
      ValueFrom = aws_ssm_parameter.APP_URL.arn
    },
    {
      Name      = "DB_CONNECTION"
      ValueFrom = aws_ssm_parameter.DB_CONNECTION.arn
    },
    {
      Name      = "DB_HOST"
      ValueFrom = aws_ssm_parameter.DB_HOST.arn
    },
    {
      Name      = "DB_PORT"
      ValueFrom = aws_ssm_parameter.DB_PORT.arn
    },
    {
      Name      = "DB_DATABASE"
      ValueFrom = aws_ssm_parameter.DB_DATABASE.arn
    },
    {
      Name      = "DB_USERNAME"
      ValueFrom = aws_ssm_parameter.DB_USERNAME.arn
    },
    {
      Name      = "DB_PASSWORD"
      ValueFrom = "${aws_db_instance.default.master_user_secret[0].secret_arn}:password::"
    },
    {
      Name      = "BROADCAST_DRIVER"
      ValueFrom = aws_ssm_parameter.BROADCAST_DRIVER.arn
    },
    {
      Name      = "CACHE_DRIVER"
      ValueFrom = aws_ssm_parameter.CACHE_DRIVER.arn
    },
    {
      Name      = "SESSION_DRIVER"
      ValueFrom = aws_ssm_parameter.SESSION_DRIVER.arn
    },
    {
      Name      = "QUEUE_DRIVER"
      ValueFrom = aws_ssm_parameter.QUEUE_DRIVER.arn
    },
    {
      Name      = "QUEUE_CONNECTION"
      ValueFrom = aws_ssm_parameter.QUEUE_CONNECTION.arn
    },
    {
      Name      = "SESSION_SECURE_COOKIE"
      ValueFrom = aws_ssm_parameter.SESSION_SECURE_COOKIE.arn
    },
    {
      Name      = "SESSION_LIFETIME"
      ValueFrom = aws_ssm_parameter.SESSION_LIFETIME.arn
    },
    {
      Name      = "REPORT_QUEUE"
      ValueFrom = aws_ssm_parameter.REPORT_QUEUE.arn
    },
    {
      Name      = "REDIS_HOST"
      ValueFrom = aws_ssm_parameter.REDIS_HOST.arn
    },
    {
      Name      = "REDIS_PASSWORD"
      ValueFrom = "${aws_secretsmanager_secret.QA_REDIS_PASSWORD.arn}:password::"
    },
    {
      Name      = "REDIS_PORT"
      ValueFrom = aws_ssm_parameter.REDIS_PORT.arn
    },
    {
      Name      = "REDIS_CLIENT"
      ValueFrom = aws_ssm_parameter.REDIS_CLIENT.arn
    },
    {
      Name      = "LOG_CHANNEL"
      ValueFrom = aws_ssm_parameter.LOG_CHANNEL.arn
    },
    {
      Name      = "MAIL_DRIVER"
      ValueFrom = aws_ssm_parameter.MAIL_DRIVER.arn
    },
    {
      Name      = "MAIL_ENCRYPTION"
      ValueFrom = aws_ssm_parameter.MAIL_ENCRYPTION.arn
    },
    {
      Name      = "MAIL_FROM_ADDRESS"
      ValueFrom = aws_ssm_parameter.MAIL_FROM_ADDRESS.arn
    },
    {
      Name      = "MAIL_FROM_NAME"
      ValueFrom = aws_ssm_parameter.MAIL_FROM_NAME.arn
    },
    {
      Name      = "MAIL_HOST"
      ValueFrom = aws_ssm_parameter.MAIL_HOST.arn
    },
    {
      Name      = "MAIL_USERNAME"
      ValueFrom = aws_ssm_parameter.MAIL_USERNAME.arn
    },
    {
      Name      = "MAIL_PASSWORD"
      ValueFrom = "${aws_secretsmanager_secret.QA_MAIL_PASSWORD.arn}:password::"
    },
    {
      Name      = "MAIL_PORT"
      ValueFrom = aws_ssm_parameter.MAIL_PORT.arn
    },
    {
      Name      = "FILESYSTEM_DRIVER"
      ValueFrom = aws_ssm_parameter.FILESYSTEM_DRIVER.arn
    },
    {
      Name      = "AWS_DEFAULT_REGION"
      ValueFrom = aws_ssm_parameter.DEFAULT_REGION.arn
    },
    {
      Name      = "AWS_BUCKET"
      ValueFrom = aws_ssm_parameter.S3_BUCKET.arn
    },
  ]
}
