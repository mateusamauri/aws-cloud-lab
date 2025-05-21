provider "aws" {
  region = "us-east-1"
}

resource "aws_s3_bucket" "site" {
  bucket = "aws-cloud-lab-mateus"

  website {
    index_document = "index.html"
  }

  tags = {
    Name        = "AWS Cloud Lab Bucket"
    Environment = "Test"
  }
}

resource "aws_s3_bucket_public_access_block" "block" {
  bucket = aws_s3_bucket.site.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_policy" "public_read" {
  bucket = aws_s3_bucket.site.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect    = "Allow"
      Principal = "*"
      Action    = "s3:GetObject"
      Resource  = "${aws_s3_bucket.site.arn}/*"
    }]
  })
}

resource "aws_s3_bucket_object" "site_files" {
  for_each = fileset("site", "**")

  bucket       = aws_s3_bucket.site.id
  key          = each.value
  source       = "site/${each.value}"
  etag         = filemd5("site/${each.value}")
  acl          = "public-read"

  content_type = lookup({
    "html" = "text/html"
    "css"  = "text/css"
  }, split(".", each.value)[1], "application/octet-stream")
}