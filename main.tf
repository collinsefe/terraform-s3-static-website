resource "aws_s3_bucket" "foo" {
  bucket = "supandoproject-staticbucketwebsite-03022025"

  force_destroy = true

  tags = {
    Name        = "AWS Static Website bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.foo.id

  index_document {
    suffix = "index.html"
  }
}

resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.foo.id
  rule {
    object_ownership = "BucketOwnerPreferred"
  }
}

resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.foo.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

resource "aws_s3_bucket_acl" "foo" {
  depends_on = [
    aws_s3_bucket_ownership_controls.this,
    aws_s3_bucket_public_access_block.this,
  ]

  bucket = aws_s3_bucket.foo.id
  acl    = "public-read"
}


resource "aws_s3_object" "object" {
  bucket       = aws_s3_bucket.foo.id
  content_type = "text/html"
  key          = "index.html"
  source       = "./index.html"
  etag         = md5(file("./index.html"))

}


resource "aws_s3_object" "foo" {
  bucket       = aws_s3_bucket.foo.id
  content_type = "text/jpg"
  key          = "contact-us.jpg"
  source       = "./contact-us.jpg"
  #   etag         = md5(file("./index.html"))

}
