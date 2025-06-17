resource "aws_s3_bucket" "private_bucket" {
  bucket        = var.bucket_name
  force_destroy = true

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-s3"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_s3_bucket_ownership_controls" "private_bucket" {
  bucket = aws_s3_bucket.private_bucket.id

  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

resource "aws_s3_bucket_public_access_block" "private_bucket_block" {
  bucket = aws_s3_bucket.private_bucket.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}
