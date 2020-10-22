provider "aws" {
  region = "us-east-2"
}


resource "aws_key_pair" "ITKey" {
 key_name   = "kd"
 public_key = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABAQDIY4Igk5iCvyShRimP7sGcBgfKdNA0LbTpkevjcyiHEGQRCmnhJY7XUzFrkvYDCQWgPx8tsAoVRZrhW10KVVNCrPTUhTselmWz8UHs/bYLhqQDAQnoygmVaawsxX+3jycSJaHsRKv1q6Sst/dGozRUhF67NsIXDKGmW/I6Up5in6hNFHQ9errI9/ac2pJqkmacjM5bU+k+/NEH9nt9nTKHBDpo6wJc/YB/n72zz+uCWPvUigRSMdtwh2PfkUecEuhGlvzBQN5sQg6cyWd8aLWauzreQK5f16dG8dFfedEb/7q7R4uZ8mutDocKZR7pyVo6x7qUTPP5+OiR3/utRRTX cloudwatch"
}
data "template_file" "startup" {
 template = "${file("ssm-agent-install.sh")}"
}

resource "aws_s3_bucket" "cloudwatch" {
  bucket = "cloudwatch-s3-terraform-bucket"
  acl = "private"
  versioning {
    enabled = true
  }
}

locals {
  userdata = templatefile("user_data.sh", {
    ssm_cloudwatch_config = aws_ssm_parameter.cw_agent.name
  })
}


resource "aws_instance" "web" {
  ami           = "ami-0a54aef4ef3b5f881"
  instance_type = "t2.micro"
  subnet_id  = "${aws_subnet.my_subnet.id}"
  vpc_security_group_ids = ["${aws_security_group.cloudwatch-node1.id}"]
  iam_instance_profile = "${aws_iam_instance_profile.test_profile.name}"
  associate_public_ip_address = true
  key_name = aws_key_pair.ITKey.key_name
  user_data = "${file("ssm-agent-install.sh")}"
  tags = {
    Name = "test"
  }
#  user_data = data.template_file.startup.rendered
}
resource "aws_ssm_parameter" "cw_agent" {
  description = "Cloudwatch agent config to configure custom log"
  name        = "/cloudwatch-agent/config"
  type        = "String"
  value       = file("cw_agent_config.json")
}
