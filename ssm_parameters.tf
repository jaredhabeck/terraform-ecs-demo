resource "aws_ssm_parameter" "APP_NAME" {
  name  = "APP_NAME"
  type  = "String"
  value = "Demo"
}

resource "aws_ssm_parameter" "APP_ENV" {
  name  = "APP_ENV"
  type  = "String"
  value = "local"
}

resource "aws_ssm_parameter" "WORKER_APP_ENV" {
  name  = "WORKER_APP_ENV"
  type  = "String"
  value = "worker"
}

resource "aws_ssm_parameter" "APP_DEBUG" {
  name  = "APP_DEBUG"
  type  = "String"
  value = "true"
}

resource "aws_ssm_parameter" "APP_LOG_LEVEL" {
  name  = "APP_LOG_LEVEL"
  type  = "String"
  value = "debug"
}

resource "aws_ssm_parameter" "APP_URL" {
  name  = "APP_URL"
  type  = "String"
  value = "https://demo.com"
}

resource "aws_ssm_parameter" "DB_CONNECTION" {
  name  = "DB_CONNECTION"
  type  = "String"
  value = "pgsql"
}

resource "aws_ssm_parameter" "DB_HOST" {
  name  = "DB_HOST"
  type  = "String"
  value = aws_db_instance.default.address
}

resource "aws_ssm_parameter" "DB_PORT" {
  name  = "DB_PORT"
  type  = "String"
  value = aws_db_instance.default.port
}

resource "aws_ssm_parameter" "DB_DATABASE" {
  name  = "DB_DATABASE"
  type  = "String"
  value = "cq"
}

resource "aws_ssm_parameter" "DB_USERNAME" {
  name  = "DB_USERNAME"
  type  = "String"
  value = aws_db_instance.default.username
}

resource "aws_ssm_parameter" "BROADCAST_DRIVER" {
  name  = "BROADCAST_DRIVER"
  type  = "String"
  value = "log"
}

resource "aws_ssm_parameter" "CACHE_DRIVER" {
  name  = "CACHE_DRIVER"
  type  = "String"
  value = "redis"
}

resource "aws_ssm_parameter" "SESSION_DRIVER" {
  name  = "SESSION_DRIVER"
  type  = "String"
  value = "redis"
}

resource "aws_ssm_parameter" "QUEUE_DRIVER" {
  name  = "QUEUE_DRIVER"
  type  = "String"
  value = "redis"
}

resource "aws_ssm_parameter" "QUEUE_CONNECTION" {
  name  = "QUEUE_CONNECTION"
  type  = "String"
  value = "redis"
}

resource "aws_ssm_parameter" "SESSION_SECURE_COOKIE" {
  name  = "SESSION_SECURE_COOKIE"
  type  = "String"
  value = "true"
}

resource "aws_ssm_parameter" "SESSION_LIFETIME" {
  name  = "SESSION_LIFETIME"
  type  = "String"
  value = "60"
}

resource "aws_ssm_parameter" "REPORT_QUEUE" {
  name  = "REPORT_QUEUE"
  type  = "String"
  value = "import"
}

resource "aws_ssm_parameter" "REDIS_HOST" {
  name  = "REDIS_HOST"
  type  = "String"
  value = aws_elasticache_replication_group.default.primary_endpoint_address
}

resource "aws_ssm_parameter" "REDIS_PORT" {
  name  = "REDIS_PORT"
  type  = "String"
  value = var.redis_port
}

resource "aws_ssm_parameter" "REDIS_CLIENT" {
  name  = "REDIS_CLIENT"
  type  = "String"
  value = "predis"
}

resource "aws_ssm_parameter" "LOG_CHANNEL" {
  name  = "LOG_CHANNEL"
  type  = "String"
  value = "stderr"
}

resource "aws_ssm_parameter" "MAIL_DRIVER" {
  name  = "MAIL_DRIVER"
  type  = "String"
  value = "smtp"
}

resource "aws_ssm_parameter" "MAIL_USERNAME" {
  name  = "MAIL_USERNAME"
  type  = "String"
  value = "smtp"
}

resource "aws_ssm_parameter" "MAIL_ENCRYPTION" {
  name  = "MAIL_ENCRYPTION"
  type  = "String"
  value = "tls"
}

resource "aws_ssm_parameter" "MAIL_FROM_ADDRESS" {
  name  = "MAIL_FROM_ADDRESS"
  type  = "String"
  value = "noreply@demo.com"
}

resource "aws_ssm_parameter" "MAIL_FROM_NAME" {
  name  = "MAIL_FROM_NAME"
  type  = "String"
  value = "Demo"
}

resource "aws_ssm_parameter" "MAIL_HOST" {
  name  = "MAIL_HOST"
  type  = "String"
  value = "email-smtp.us-east-1.amazonaws.com"
}

resource "aws_ssm_parameter" "MAIL_PORT" {
  name  = "MAIL_PORT"
  type  = "String"
  value = "587"
}

resource "aws_ssm_parameter" "FILESYSTEM_DRIVER" {
  name  = "FILESYSTEM_DRIVER"
  type  = "String"
  value = "s3"
}

resource "aws_ssm_parameter" "DEFAULT_REGION" {
  name  = "DEFAULT_REGION"
  type  = "String"
  value = "us-east-2"
}

resource "aws_ssm_parameter" "S3_BUCKET" {
  name  = "S3_BUCKET"
  type  = "String"
  value = "demo-bucket"
}
