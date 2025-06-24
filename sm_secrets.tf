# Note DB_PASSWORD within secret manager is created automatically by RDS
# via TF RDS resource setting `manage_master_user_password`

# set prevent_destroy because SM secrets require 7 days for deletion,
# causing terraform destroy dependency errors, secrets must always be
# renamed upon recreation if inside deletion period
resource "aws_secretsmanager_secret" "QA_APP_KEY" {
  name = "QA_APP_KEY"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret" "QA_REDIS_PASSWORD" {
  name = "QA_REDIS_PASSWORD"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret" "QA_MAIL_PASSWORD" {
  name = "QA_MAIL_PASSWORD"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret" "QA_TINYMCE_KEY" {
  name = "QA_TINYMCE_KEY"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret" "QA_MOMENTIVE_ACCESS_TOKEN" {
  name = "QA_MOMENTIVE_ACCESS_TOKEN"

  lifecycle {
    prevent_destroy = true
  }
}

resource "aws_secretsmanager_secret" "QA_PENDO_API_KEY" {
  name = "QA_PENDO_API_KEY"

  lifecycle {
    prevent_destroy = true
  }
}
