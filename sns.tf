resource "aws_sns_topic" "cld-topic" {
  name = "test"
  delivery_policy = <<EOF
{
  "http": {
    "defaultHealthyRetryPolicy": {
      "minDelayTarget": 20,
      "maxDelayTarget": 20,
      "numRetries": 3,
      "numMaxDelayRetries": 0,
      "numNoDelayRetries": 0,
      "numMinDelayRetries": 0,
      "backoffFunction": "linear"
    },
    "disableSubscriptionOverrides": false,
    "defaultThrottlePolicy": {
      "maxReceivesPerSecond": 1
    }
  }
}
EOF
}
resource "aws_sqs_queue" "queue" {
  name = "test"
}

resource "aws_sns_topic_subscription" "sqs_target" {
  topic_arn = "${aws_sns_topic.cld-topic.arn}"
  protocol  = "sqs"
  endpoint  = "${aws_sqs_queue.queue.arn}"
}
