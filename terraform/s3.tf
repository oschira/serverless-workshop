resource "aws_s3_bucket" "bucket_upload" {
  bucket = "acg-osc-sfb-upload"

  force_destroy = true

  tags = {
    Name        = "acg-osc-sfb-upload"
    Project     = "serverless-workshop"
    Environment = "dev"
  }
}

resource "aws_s3_bucket" "bucket_transcoded" {
  bucket = "acg-osc-sfb-transcoded"

  force_destroy = true

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
      {
          "Sid": "AddPerm",
          "Effect": "Allow",
          "Principal": "*",
          "Action": "s3:GetObject",
          "Resource": "arn:aws:s3:::acg-osc-sfb-transcoded/*"
      }
  ]
}
POLICY

  tags = {
    Name        = "acg-osc-sfb-transcoded"
    Project     = "serverless-workshop"
    Environment = "dev"
  }
}
