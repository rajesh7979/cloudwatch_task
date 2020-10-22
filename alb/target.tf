data "aws_vpc" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.vpc_name]
  }
}

resource "aws_lb_target_group" "lb_target" {
  name     = local.cluster_target_group
  port     = "443"
  protocol = "HTTPS"
  vpc_id   = data.aws_vpc.selected.id

  tags = {
    name    = local.cluster_target_group,
    project = var.clusterName
  }

  stickiness {
    type            = "lb_cookie"
    cookie_duration = 1800
    enabled         = "true"
  }

  health_check {
    protocol            = "HTTPS"
    healthy_threshold   = 3
    unhealthy_threshold = 10
    timeout             = 5
    interval            = 10
    path                = var.health_check_path
    port                = "443"
  }
}

data "aws_instance" "selected" {
  count = 3
  filter {
    name   = "tag:Name"
    values = ["${var.clusterName}_Server${count.index}"]
  }
}


resource "aws_lb_target_group_attachment" "instance" {
  count            = 3
  target_group_arn = aws_lb_target_group.lb_target.arn
  target_id        = data.aws_instance.selected[count.index].id
  port             = 443
}

