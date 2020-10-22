#-----------------------------------KMS Key---------------------------------------------#
resource "aws_kms_key" "KMSkey" {
  description             = "This key is used to encrypt bucket objects"
  deletion_window_in_days = 10
}

#------------------------------S3 Bucket for Access Logs of CloudTrail Bucket----------------------#

resource "aws_s3_bucket" "s3_access_log_bucket" {
  bucket = "${var.Name}-s3-server-access-log-bucket"
  acl    = "log-delivery-write"
  force_destroy = true
  # versioning {
  #   enabled = true
    
  # }
   
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.KMSkey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }

  tags = {
    Name    = "${var.Name}-s3-server-access-log-bucket"
    Project = var.Name
  }

}

#Block public access for S3 Access Logs Bucket
resource "aws_s3_bucket_public_access_block" "access_log_bucket" {
  bucket = aws_s3_bucket.s3_access_log_bucket.id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true
}

#-----------------------------S3 Bucket for CloudTrail----------------------------------#

resource "aws_s3_bucket" "trailcloud-test" {

  bucket          = "cloudtrail-bucket-mytest"
  acl             = "private"
  force_destroy   =  true

  versioning {
    enabled = true
  }
   
  server_side_encryption_configuration {
    rule {
      apply_server_side_encryption_by_default {
        kms_master_key_id = aws_kms_key.KMSkey.arn
        sse_algorithm     = "aws:kms"
      }
    }
  }


  # aws_ssm_parameter.cw_agent1 will be destroyed
  #  - resource "aws_ssm_parameter" "cw_agent1" {
  #     - arn         = "arn:aws:ssm:us-east-2:101773140689:parameter/cloudwatch-agent/config" -> null
  #    - data_type   = "text" -> null
  #    - description = "Cloudwatch agent config to configure custom log" -> null
  #    - id          = "/cloudwatch-agent/config" -> null
  #    - name        = "/cloudwatch-agent/config" -> null
  #    - overwrite   = true -> null
  #    - tags        = {} -> null
  #    - tier        = "Standard" -> null
  #    - type        = "String" -> null
  #    - value       = (sensitive value)
  #    - version     = 2 -> null
  #  }


  logging {
    target_bucket = aws_s3_bucket.s3_access_log_bucket.id
    target_prefix = "S3ServerAccessLogs/"
  }

  lifecycle_rule {
    enabled = true

    expiration {
      days          = var.current_version_expiration_days
    }

    transition {
      days          = var.current_glacier_transition_days
      storage_class = "GLACIER"
    }


    noncurrent_version_expiration {
      days          = var.noncurrent_version_expiration_days
    }

    noncurrent_version_transition {
      days          = var.noncurrent_glacier_transition_days
      storage_class = "GLACIER"
    }
  }

  tags = {
    //Name    = "${var.Name}-cloudtrail"
    Project = var.Name
  }

}


#Block public access for CloudTrail Bucket
resource "aws_s3_bucket_public_access_block" "cloudtrail_bucket" {
  bucket = aws_s3_bucket.trailcloud-test.id

  block_public_acls         = true
  block_public_policy       = true
  ignore_public_acls        = true
  restrict_public_buckets   = true
}

#------------------------------S3 Bucket policy for cloudTrail Bucket------------------------------------#
resource "aws_s3_bucket_policy" "bucket_policy" {
  depends_on = [aws_s3_bucket.trailcloud-test,aws_s3_bucket_public_access_block.access_log_bucket]
  bucket = aws_s3_bucket.trailcloud-test.id
  policy = <<-EOF
  {

    "Version": "2012-10-17",
    "Statement": [{
        "Sid": "AWSCloudTrailAclCheck",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:GetBucketAcl",
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.trailcloud-test.id}"
        ]

      },
      {
        "Sid": "AWSCloudTrailWrite",
        "Effect": "Allow",
        "Principal": {
          "Service": "cloudtrail.amazonaws.com"
        },
        "Action": "s3:PutObject",
        "Resource": [
          "arn:aws:s3:::${aws_s3_bucket.trailcloud-test.id}/*"
        ],
        "Condition": {
          "StringEquals": {
            "s3:x-amz-acl": "bucket-owner-full-control"
          }
        }
      }


    ]
  }
EOF
}


#-------------------------------CloudTrail----------------------------------------------#
resource "aws_cloudtrail" "trail" {
  name           = "${var.Name}-cloudtrail"
  s3_bucket_name = aws_s3_bucket.trailcloud-test.id
  s3_key_prefix  = var.s3_key_prefix

  enable_logging                = var.enable_logging
  include_global_service_events = var.include_global_service_events
  is_multi_region_trail         = var.is_multi_region_trail
  enable_log_file_validation    = var.enable_log_file_validation
  
  tags = {
    Project = var.Name
  }
  depends_on = [aws_s3_bucket.trailcloud-test,aws_s3_bucket.s3_access_log_bucket,aws_s3_bucket_policy.bucket_policy]
}

#------------------------------SNS Topic --------------------------------------------------------#


