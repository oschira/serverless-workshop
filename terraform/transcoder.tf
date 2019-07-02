resource "aws_elastictranscoder_pipeline" "transcoding-pipeline" {
  input_bucket = "${aws_s3_bucket.bucket_upload.bucket}"
  name         = "acg-osc-sfb-transcoding-pipeline"
  role         = "${aws_iam_role.lambda-s3-execute-transcoding.arn}"

  content_config {
    bucket        = "${aws_s3_bucket.bucket_transcoded.bucket}"
    storage_class = "Standard"
  }

  thumbnail_config {
    bucket        = "${aws_s3_bucket.bucket_transcoded.bucket}"
    storage_class = "Standard"
  }
}
