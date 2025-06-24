# TODO for multi_az flip marked boolean param
resource "aws_db_instance" "default" {
  allocated_storage           = 64
  db_name                     = "${var.app_name}_db"
  db_subnet_group_name        = aws_db_subnet_group.default.name
  vpc_security_group_ids      = [aws_security_group.database_sg.id]
  engine                      = "postgres"
  engine_version              = "15.4"
  instance_class              = var.rds_instance_class
  multi_az                    = false
  username                    = "postgres"
  manage_master_user_password = true
  backup_retention_period     = 0
  apply_immediately           = true
  storage_type                = "gp2"
  skip_final_snapshot         = true

  tags = merge(local.tags, {
    Name = "${var.app_name}-rds-db"
  })
}

resource "aws_db_subnet_group" "default" {
  name       = "${var.app_name}_db_subnet_group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]

  tags = merge(local.tags, {
    Name = "${var.app_name}-rds-subnet-group"
  })
}
