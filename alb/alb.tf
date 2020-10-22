resource "aws_kms_key" "s3key" {
  description             = "This key is used to encrypt bucket objects for Sass ALB logs"
  deletion_window_in_days = 10
}

resource "aws_s3_bucket" "s3_access" {
  bucket = "${var.Name}-alb-s3-access"
  acl    = "private"

  versioning {
    enabled = true
  }

  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.s3key.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name    = "${var.Name}-alb-s3-access"
    Project = var.Name
  }
}

data "aws_security_group" "selected" {
  filter {
    name   = "tag:Name"
    values = [local.security_group_alb_name]
  }
}

data "aws_subnet" "selectedAA" {

  filter {
    name   = "tag:Name"
    values = [local.subnet_private_AA_name]
  }
}

data "aws_subnet" "selectedBB" {

  filter {
    name   = "tag:Name"
    values = [local.subnet_private_BB_name]
  }
}

resource "aws_lb" "lb" {

  #  provider           = aws.platformdev 
  name               = "${var.Name}-privateA-ALB"
  subnets            = [data.aws_subnet.selectedAA.id, data.aws_subnet.selectedBB.id]
  security_groups    = [data.aws_security_group.selected.id, ]
  load_balancer_type = var.load_balancer_type
  internal           = "true"
  idle_timeout       = "60"

  tags = {
    Name = "${var.Name}-LB"
  }

  access_logs {
    bucket = "${var.Name}-lb-s3-access"
    prefix = "ELB-logs"
  }
}

