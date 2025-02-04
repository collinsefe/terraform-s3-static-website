# AWS S3 Static Website Deployment with Terraform

## Overview
This Terraform script provisions an **AWS S3 bucket** configured to host a static website. The configuration ensures that the bucket supports public access, ownership controls, and stores essential website files, including HTML and images.

## Features
- Creates an **S3 bucket** for static website hosting.
- Configures **index.html** as the default landing page.
- Sets **public read access** for hosted content.
- Uploads an HTML page (`index.html`) and images (`contact-us.jpg`, `website.png`).
- Allows full bucket ownership control.
- Applies an **S3 bucket policy** to allow public read access to the website.
- Outputs the **S3 bucket URL endpoint** for easy access.

## Prerequisites
Ensure you have the following installed:
- [Terraform](https://developer.hashicorp.com/terraform/downloads)
- AWS CLI configured with appropriate credentials.

## Terraform Configuration

### **1️⃣ Initialize Terraform**
Run the following command to initialize the Terraform project:
```sh
terraform init
```

### **2️⃣ Validate Configuration**
Check for syntax errors in your Terraform code:
```sh
terraform validate
```

### **3️⃣ Apply Configuration**
Deploy the resources to AWS:
```sh
terraform apply -auto-approve
```

### **4️⃣ Verify Website Deployment**
Once applied, obtain the S3 website endpoint:
```sh
echo "http://$(terraform output -raw bucket_url_endpoint)"
```
Open the URL in a browser to confirm the website is live.

## Terraform Code Breakdown

```hcl
resource "aws_s3_bucket" "foo" {
  bucket = "staticwebsitebucket-03022025"
  force_destroy = true
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

resource "aws_s3_bucket_policy" "that" {
  bucket = aws_s3_bucket.foo.id
  policy = data.aws_iam_policy_document.static_website.json
}

data "aws_iam_policy_document" "static_website" {
  statement {
    effect = "Allow"

    actions = [
      "s3:GetObject"
    ]

    resources = [
      aws_s3_bucket.foo.arn,
      "${aws_s3_bucket.foo.arn}/*",
    ]

    principals {
      type        = "AWS"
      identifiers = ["*"]
    }
  }
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
  content_type = "image/jpeg"
  key          = "contact-us.jpg"
  source       = "./contact-us.jpg"
  etag         = filemd5("./contact-us.jpg")
}

resource "aws_s3_object" "this" {
  bucket       = aws_s3_bucket.foo.id
  content_type = "image/png"
  key          = "website.png"
  source       = "./website.png"
  etag         = filemd5("./website.png")
}

output "bucket_url_endpoint" {
  value = aws_s3_bucket.foo.bucket_domain_name
}
```

## Cleanup
To destroy the created AWS resources, run:
```sh
terraform destroy -auto-approve
```

## Notes
- Ensure **index.html** and images (`contact-us.jpg`, `website.png`) exist in your local directory before applying Terraform.
- AWS **may block public access** by default. 
  We created an S3 bucket policy to allow public-read access.
- You can configure **CloudFront** for enhanced performance and security.

## Author
Developed by **Collins Orighose** for the **Supando AWS Project**

---
_This project demonstrates AWS static website hosting with Terraform._ 🚀

