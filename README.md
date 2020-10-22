# Creating of EC2 instance Using terraform 
Creation ec2 resource using following parameters
ami ID 
region
subnet ID
SG
IAM 
Instance profile 
key ID 

file = ec2.tf


# networking (VPC)

created vpc and subnets that attached ec2 instance for what we have created.


# S3 

Created s3 bucket  


#  IAM role 
created IAM role for Cloudwatch and attached policy to the roles 
and added the role to ec2 instance which we have created.
created IAM role for cloudtrail and attached the role to s3 bucket 

Module  file = iam.tf

# SNS
created sns topic and subcribed the topic 

Module file = sns.tf



# cloudwatch
created alarm for ec2 

Metrics:
CPUutilization >70
status check   >70
disk space read/write >70 
memory utilization  >70

events:
s3 bucket deletion
created event rule on s3 bucket deletion and added to target endpoint with target ID sendtoSNS


Module file = cloudwatch.tf



