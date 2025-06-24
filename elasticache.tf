resource "aws_elasticache_cluster" "redis" {
  cluster_id           = "redis-cluster"
  replication_group_id = aws_elasticache_replication_group.default.id

  tags = {
    Name = "${var.app_name}-elasticache-cluster"
  }
}

resource "aws_elasticache_replication_group" "default" {
  description                 = "redis elasticache replication group"
  automatic_failover_enabled  = true
  engine                      = "redis"
  engine_version              = "7.2"
  node_type                   = "cache.t3.micro"
  num_cache_clusters          = 2
  parameter_group_name        = "default.redis7"
  port                        = var.redis_port
  preferred_cache_cluster_azs = ["us-east-2a", "us-east-2b"]
  replication_group_id        = "${var.app_name}-elasticache-replication-group"
  security_group_ids          = [aws_security_group.redis_sg.id]
  subnet_group_name           = aws_elasticache_subnet_group.redis.name

  /* flip bits to enable multi-az
  multi_az_enabled = true
  automatic_failover_enabled = true
  */

  lifecycle {
    ignore_changes = [num_cache_clusters]
  }

  tags = {
    Name = "${var.app_name}-elasticache-replication-group"
  }
}

resource "aws_elasticache_subnet_group" "redis" {
  name       = "${var.app_name}-redis-subnet-group"
  subnet_ids = [aws_subnet.private.id, aws_subnet.private2.id]

  tags = {
    Name = "${var.app_name}-elasticache-subnet-group"
  }
}
