resource "aws_s3_bucket" "private_bucket" {
  bucket        = "${var.application_name}-${var.environment_name}-bucket-test"
  force_destroy = true

  tags = {
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


# data "aws_vpc_endpoint" "s3" {
#   vpc_id = aws_vpc.main.id
#   filter {
#     name   = "service-name"
#     values = ["com.amazonaws.${var.primary_region}.s3"]
#   }

#   depends_on = [aws_vpc_endpoint.s3]
# }

# resource "aws_s3_bucket_policy" "restrict_to_vpc_endpoint" {
#   bucket = aws_s3_bucket.private_bucket.id

#   policy = jsonencode({
#     Version = "2012-10-17",
#     Statement = [
#       {
#         Sid       = "AllowAccessFromVPCE",
#         Effect    = "Deny"
#         # Principal = "*",
#         Action    = "s3:*",
#         Resource = [
#           "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}",
#           "arn:aws:s3:::${aws_s3_bucket.private_bucket.bucket}/*"
#         ],
#         Condition = {
#           StringEquals = {
#             "aws:sourceVpce" = aws_vpc_endpoint.s3.id
#           }
#         }
#       }
#     ]
#   })
# }

