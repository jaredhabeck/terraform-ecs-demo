# Security Groups

# Web instance SG
# create_before_destroy is used because there are huge dependency
# chains that can occur on security groups causing terrform destroy issues
resource "aws_security_group" "web_sg" {
  vpc_id = aws_vpc.default.id

  name_prefix = "${var.app_name}-web-sg"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-web-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "web_sg_ingress" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = var.cidr_block
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = merge(local.tags, {
    Name = "${var.app_name}-web-ingress-rule"
  })
}

resource "aws_vpc_security_group_egress_rule" "web_sg_egress" {
  security_group_id = aws_security_group.web_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  ip_protocol = "-1"

  tags = merge(local.tags, {
    Name = "${var.app_name}-web-egress-rule"
  })
}

# ALB SG
resource "aws_security_group" "alb_sg" {
  vpc_id = aws_vpc.default.id

  name_prefix = "${var.app_name}_alb_sg"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-alb-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_443" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 443
  ip_protocol = "tcp"
  to_port     = 443

  tags = merge(local.tags, {
    Name = "${var.app_name}-alb-ingress-rule"
  })
}

resource "aws_vpc_security_group_ingress_rule" "alb_sg_ingress_80" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = "0.0.0.0/0"
  from_port   = 80
  ip_protocol = "tcp"
  to_port     = 80

  tags = merge(local.tags, {
    Name = "${var.app_name}-alb-ingress-rule"
  })
}

resource "aws_vpc_security_group_egress_rule" "alb_sg_egress" {
  security_group_id = aws_security_group.alb_sg.id

  cidr_ipv4   = var.cidr_block
  ip_protocol = "-1"

  tags = merge(local.tags, {
    Name = "${var.app_name}-alb-egress-rule"
  })
}

# Database (Postgres RDS) SG
resource "aws_security_group" "database_sg" {
  vpc_id = aws_vpc.default.id

  name_prefix = "${var.app_name}-database-sg"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-database-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "database_sg_ingress" {
  security_group_id = aws_security_group.database_sg.id

  cidr_ipv4   = var.cidr_block
  from_port   = 5432
  ip_protocol = "tcp"
  to_port     = 5432

  tags = merge(local.tags, {
    Name = "${var.app_name}-db-ingress-rule"
  })
}

resource "aws_vpc_security_group_egress_rule" "database_sg_egress" {
  security_group_id = aws_security_group.database_sg.id

  cidr_ipv4   = var.cidr_block
  ip_protocol = "-1"

  tags = merge(local.tags, {
    Name = "${var.app_name}-db-egress-rule"
  })
}

# Elasticache (Redis) SG
resource "aws_security_group" "redis_sg" {
  vpc_id = aws_vpc.default.id

  name_prefix = "${var.app_name}_redis_sg"

  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-redis-sg"
  })
}

resource "aws_vpc_security_group_ingress_rule" "redis_sg_ingress" {
  security_group_id = aws_security_group.redis_sg.id

  cidr_ipv4   = var.cidr_block
  ip_protocol = "tcp"
  from_port   = 6379
  to_port     = 6379

  tags = merge(local.tags, {
    Name = "${var.app_name}-redis-ingress-rule"
  })
}

resource "aws_vpc_security_group_egress_rule" "redis_sg_egress" {
  security_group_id = aws_security_group.redis_sg.id

  cidr_ipv4   = var.cidr_block
  ip_protocol = "-1"

  tags = merge(local.tags, {
    Name = "${var.app_name}-redis-egress-rule"
  })
}
