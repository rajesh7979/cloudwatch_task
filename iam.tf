resource "aws_iam_user" "user" {
  name = "test-user"
}



resource "aws_iam_role" "test_role" {
  name = "test_role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "ec2.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    }
  ]
}
EOF

  tags = {
      tag-key = "tag-value"
  }
}

resource "aws_iam_role_policy" "test_policy" {
  name = "test_policy"
  role = aws_iam_role.test_role.id

  policy = <<-EOF
  {
    "Version": "2012-10-17",
    "Statement": [
      {
        "Action": [
          "s3:*"
        ],
        "Effect": "Allow",
        "Resource": "*"
      }
    ]
  }
  EOF
}

resource "aws_iam_role" "eventwatch_exec_role" {
        name = "eventwatch_exec_role"
        assume_role_policy = <<EOF
{   
        "Version": "2012-10-17",
        "Statement": [
                {
                        "Action": "sts:AssumeRole",
                        "Principal": {
                                "Service": "lambda.amazonaws.com"
                        },
                        "Effect": "Allow",
                        "Sid": ""
                }
        ]
}
EOF
}
data "aws_iam_policy_document" "eventwatch_s3_full_doc" {
    statement {
        actions = [
            "s3:*",
        ]   
        resources = [
            "arn:aws:s3:::*",
        ]   
    }   
}
resource "aws_iam_policy" "eventwatch_s3_full" {
    name = "eventwatch_s3_full"
    path = "/"
    policy = "${data.aws_iam_policy_document.eventwatch_s3_full_doc.json}"
}
resource "aws_iam_role_policy_attachment" "eventwatch_s3_policy_attach" {
    role       = "${aws_iam_role.eventwatch_exec_role.name}"
    policy_arn = "${aws_iam_policy.eventwatch_s3_full.arn}"
}

 resource "aws_iam_policy" "policy" {
  name        = "test-policy"
  description = "A test policy"
  policy      = "${file("cloudwatch.json")}"
  }
         


resource "aws_iam_instance_profile" "test_profile" {
  name = "test_profile"
  role = "${aws_iam_role.test_role.name}"
}

 resource "aws_iam_policy_attachment" "test-attach" {
  name       = "test-attachment"
  users      = [aws_iam_user.user.name]
  roles      = [aws_iam_role.test_role.name]
  policy_arn = aws_iam_policy.policy.arn
 }

resource "aws_iam_role_policy_attachment" "dev-resources-ssm-policy" {
role       = aws_iam_role.test_role.name
policy_arn = "arn:aws:iam::aws:policy/AmazonSSMManagedInstanceCore"
}
