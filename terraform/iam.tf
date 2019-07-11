resource "aws_iam_role" "lambda-s3-execute-transcoding" {
  name        = "lambda-s3-execute-transcoding"
  description = "IAM role for transcoding lambda"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Action": "sts:AssumeRole",
      "Principal": {
        "Service": "elastictranscoder.amazonaws.com"
      },
      "Effect": "Allow",
      "Sid": ""
    },
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

  tags = {
    Name        = "lambda-s3-execute-transcoding"
    Project     = "serverless-workshop"
    Environment = "dev"
  }
}

# attach AWSLambdaExecute policy

data "aws_iam_policy" "AWSLambdaExecute" {
  arn = "arn:aws:iam::aws:policy/AWSLambdaExecute"
}

resource "aws_iam_role_policy_attachment" "attach-AWSLambdaExecute" {
  role       = "${aws_iam_role.lambda-s3-execute-transcoding.name}"
  policy_arn = "${data.aws_iam_policy.AWSLambdaExecute.arn}"
}

# attach AmazonElasticTranscoder_JobsSubmitter policy

data "aws_iam_policy" "AmazonElasticTranscoder_JobsSubmitter" {
  arn = "arn:aws:iam::aws:policy/AmazonElasticTranscoder_JobsSubmitter"
}

resource "aws_iam_role_policy_attachment" "attach-AmazonElasticTranscoder_JobsSubmitter" {
  role       = "${aws_iam_role.lambda-s3-execute-transcoding.name}"
  policy_arn = "${data.aws_iam_policy.AmazonElasticTranscoder_JobsSubmitter.arn}"
}
