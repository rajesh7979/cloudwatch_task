data "aws_acm_certificate" "amazon_issued" {
  domain      = "*.${var.route53-dns}"
  types       = ["AMAZON_ISSUED"]
  most_recent = true
}

resource "aws_lb_listener" "lb_listener" {

  load_balancer_arn = aws_lb.lb.arn
  port              = "443"
  protocol          = "HTTPS"
  ssl_policy        = "ELBSecurityPolicy-2016-08"
  certificate_arn   = data.aws_acm_certificate.amazon_issued.arn

  default_action {
    target_group_arn = aws_lb_target_group.lb_target.arn
    type             = "forward"
  }
}

resource "aws_lb_listener" "http-to-https" {
  load_balancer_arn = aws_lb.lb.arn

  port     = "80"
  protocol = "HTTP"

  default_action {
    type = "redirect"

    redirect {
      port        = "443"
      protocol    = "HTTPS"
      status_code = "HTTP_301"
    }
  }
}

resource "aws_lb_listener_rule" "listener_rule" {
  depends_on   = [aws_lb_target_group.lb_target]
  listener_arn = aws_lb_listener.lb_listener.arn

  action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.lb_target.id
  }

  condition {
    path_pattern {
      values = ["/*"]
    }
  }
}

