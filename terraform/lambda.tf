resource "aws_lambda_function" "transcode-video" {
  filename      = "../lab-1/lambda/video-transcoder/Lambda-Deployment.zip"
  function_name = "acg-osc-sfb-transcode-video"
  role          = aws_iam_role.lambda-s3-execute-transcoding.arn
  handler       = "index.handler"

  source_code_hash = filebase64sha256("../lab-1/lambda/video-transcoder/Lambda-Deployment.zip")

  runtime = "nodejs10.x"
  timeout = 30

  environment {
    variables = {
      ELASTIC_TRANSCODER_REGION = var.aws_region
      ELASTIC_TRANSCODER_PIPELINE_ID = aws_elastictranscoder_pipeline.transcoding-pipeline.id
    }
  }
}

# trigger lambda from s3 upload

resource "aws_lambda_permission" "allow_bucket_upload_to_transcode_video" {
  statement_id  = "AllowExecutionFromS3Bucket"
  action        = "lambda:InvokeFunction"
  function_name = "${aws_lambda_function.transcode-video.arn}"
  principal     = "s3.amazonaws.com"
  source_arn    = "${aws_s3_bucket.bucket_upload.arn}"
}

resource "aws_s3_bucket_notification" "bucket_notification_video_uploaded" {
  bucket = "${aws_s3_bucket.bucket_upload.id}"

  lambda_function {
    lambda_function_arn = "${aws_lambda_function.transcode-video.arn}"
    events              = ["s3:ObjectCreated:*"]
  }
}
