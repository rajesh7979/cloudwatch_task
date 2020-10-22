resource "aws_cloudwatch_dashboard" "main" {
dashboard_name = "test1"

  dashboard_body = <<EOF

{
  "widgets": [
    {
      "type": "metric",
      "x": 0,
      "y": 0,
      "width": 12,
      "height": 6,
      "properties": {
        "metrics": [
          [
            "AWS/EC2",
            "CPUUtilization",
            "InstanceId",
            "${aws_instance.web.id}"
          ]
        ],
        "period": 300,
        "stat": "Average",
        "region": "us-east-2",
        "title": "EC2 Instance CPU"
      }
    },
    {
      "type": "text",
      "x": 0,
      "y": 7,
      "width": 3,
      "height": 3,
      "properties": {
        "markdown": "test"
      }
    }
  ]
}
EOF
}

# --------------------alarm for cpu utilization ---------------------#

resource "aws_cloudwatch_metric_alarm" "cpu" {
  alarm_name                = "terraform-cpu"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "CPUUtilization"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors ec2 cpu utilization"
  dimensions = {
        InstanceId = "${aws_instance.web.id}"
      }
  alarm_actions             = ["${aws_sns_topic.cld-topic.arn}"]
  insufficient_data_actions = []
}
# ------------------alarm for memory utilization ---------------------#

# resource "aws_cloudwatch_metric_alarm" "memory-avail" {
#  alarm_name                = "terraform-memory"
#  comparison_operator       = "GreaterThanThreshold"
#  evaluation_periods        = "1"
#  metric_name               = "mem_available_percent"
#  namespace                 = "CWAgent"
#  period                    = "600"
#  statistic                 = "Average"
#  threshold                 = "70"
#  alarm_description         = "This metric monitors ec2 memory  utilization"
#  dimensions = {
#        InstanceId = "${aws_instance.web.id}"
#      }
#  alarm_actions             = ["${aws_sns_topic.cld-topic.arn}"]
#  insufficient_data_actions = []
# }
#-------------------alarm for status checks --------------------------#

resource "aws_cloudwatch_metric_alarm" "checks" {
  alarm_name                = "terraform-status-check"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "2"
  metric_name               = "StatusCheckFailed"
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "0"
  alarm_description         = "This metric monitors ec2 status check utilization"
  dimensions = {
        InstanceId = "${aws_instance.web.id}"
      }
  alarm_actions             = ["${aws_sns_topic.cld-topic.arn}"]
  insufficient_data_actions = []
}

#--------------------alarm for Disk space ----------------------------#
resource "aws_cloudwatch_metric_alarm" "disk-space" {
  alarm_name                = "terraform-disk-space"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "DiskWriteBytes"
  namespace                 = "AWS/EC2"
  period                    = "600"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors ec2 disk spaceu utilization"
  dimensions = {
        InstanceId = "${aws_instance.web.id}"
      }
  alarm_actions             = ["${aws_sns_topic.cld-topic.arn}"]
  insufficient_data_actions = []
}

resource "aws_cloudwatch_metric_alarm" "disk" {
  alarm_name                = "terraform-disk-read"
  comparison_operator       = "GreaterThanThreshold"
  evaluation_periods        = "1"
  metric_name               = "DiskReadBytes"
  namespace                 = "AWS/EC2"
  period                    = "600"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors ec2 disk spaceu utilization"
  dimensions = {
        InstanceId = "${aws_instance.web.id}"
      }
  alarm_actions             = ["${aws_sns_topic.cld-topic.arn}"]
  insufficient_data_actions = []
}


#-----------------alarm for s3 bucket object for cloudtrail-----------#

resource "aws_cloudwatch_metric_alarm" "s3-terraform" {
  alarm_name                = "terraform-s3"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "1"
  metric_name               = "BucketSizeBytes"
  namespace                 = "AWS/s3"
  period                    = "600"
  statistic                 = "Average"
  threshold                 = "70"
  alarm_description         = "This metric monitors s3  bucketsize"
  dimensions = {
        BucketName  = "${aws_s3_bucket.cloudwatch.id}"
        StorageType = "StandardStorage"
       
      }
  alarm_actions             = ["${aws_sns_topic.cld-topic.arn}"]
  insufficient_data_actions = []
}

#----------------cloudwatch rule for s3 ------------------------------#
resource "aws_cloudwatch_event_rule" "s3-events" {
  name        = "s3-events"
  description = "s3 deletion notification"
  schedule_expression = "rate(1 minute)"
  event_pattern = <<PATTERN
{
  "source": [
    "aws.s3"
  ],
  "detail-type": [
    "AWS API Call via CloudTrail"
  ],
  "detail": {
    "eventSource": [
      "s3.amazonaws.com"
    ],
    "eventName": [
      "DeleteBucket"
    ]
  }
}
PATTERN
}

resource "aws_cloudwatch_event_target" "s3_target" {
  rule      = "${aws_cloudwatch_event_rule.s3-events.name}"
  target_id = "SendToSNS" 
  arn       = "${aws_sns_topic.cld-topic.arn}"
}

#-----------------cloudwatc events rule SG ------------------------------#


