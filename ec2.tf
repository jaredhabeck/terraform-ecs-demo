# EC2 via Launch Template and ASG
resource "aws_launch_template" "default" {
  name_prefix   = var.app_name
  image_id      = var.ecs_ec2_ami
  instance_type = var.ecs_ec2_instance_type
  key_name      = var.ssh_key_name
  user_data = base64encode(templatefile(
    "${path.module}/user_data.sh",
    { ecs_cluster_name = aws_ecs_cluster.default.name }
  ))
  vpc_security_group_ids = [aws_security_group.web_sg.id]

  iam_instance_profile {
    arn = aws_iam_instance_profile.ec2_container_instance_role_profile.arn
  }

  tag_specifications {
    resource_type = "instance"

    tags = merge(local.tags, {
      Name = "${var.app_name}-container-instance"
    })
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-launch-template"
  })

}

resource "aws_autoscaling_group" "web" {
  vpc_zone_identifier   = [aws_subnet.private.id, aws_subnet.private2.id]
  desired_capacity      = 1
  max_size              = 1
  min_size              = 1
  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

resource "aws_autoscaling_group" "worker" {
  vpc_zone_identifier   = [aws_subnet.private.id, aws_subnet.private2.id]
  desired_capacity      = 1
  max_size              = 1
  min_size              = 1
  protect_from_scale_in = true

  launch_template {
    id      = aws_launch_template.default.id
    version = "$Latest"
  }

  tag {
    key                 = "AmazonECSManaged"
    value               = true
    propagate_at_launch = true
  }
}

#ALB
resource "aws_lb" "default" {
  name                       = "${var.app_name}-alb"
  internal                   = false
  load_balancer_type         = "application"
  security_groups            = [aws_security_group.alb_sg.id]
  subnets                    = [aws_subnet.public.id, aws_subnet.public2.id]
  enable_deletion_protection = false

  /* enable optional access logs
  access_logs {
    bucket  = aws_s3_bucket.lb_logs.id
    prefix  = "test-lb"
    enabled = true
  }
  */

  tags = merge(local.tags, {
    Name = "${var.app_name}-alb"
  })
}

resource "aws_lb_target_group" "default" {
  name        = "${var.app_name}-alb-tg"
  port        = 80
  protocol    = "HTTP"
  vpc_id      = aws_vpc.default.id
  target_type = "ip"

  health_check {
    healthy_threshold   = "3"
    interval            = "300"
    protocol            = "HTTP"
    matcher             = "302"
    timeout             = "3"
    path                = "/"
    unhealthy_threshold = "2"
  }

  # averts delete failures
  lifecycle {
    create_before_destroy = true
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-target-group"
  })
}

resource "aws_lb_listener" "default" {
  load_balancer_arn = aws_lb.default.id
  port              = "80"
  protocol          = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-lb-listener-redirect"
  })
}

resource "aws_lb_listener" "default_ssl" {
  load_balancer_arn = aws_lb.default.id
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-TLS13-1-2-2021-06"
  certificate_arn   = var.ssl_certificate_arn

  default_action {
    target_group_arn = aws_lb_target_group.default.id
    type             = "forward"
  }

  tags = merge(local.tags, {
    Name = "${var.app_name}-lb-listener-ssl"
  })
}
