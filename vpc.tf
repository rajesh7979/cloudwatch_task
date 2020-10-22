resource "aws_vpc" "test" {
  cidr_block = "172.16.0.0/16"

  tags = {
    Name = "clv"
  }
}

resource "aws_subnet" "my_subnet" {
  vpc_id            = aws_vpc.test.id
  cidr_block        = "172.16.10.0/24"
  availability_zone = "us-east-2a"

  tags = {
    Name = "clve"
  }
}

