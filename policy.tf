# resource "aws_s3_bucket_policy" "that" {
#   bucket = aws_s3_bucket.foo.id
#   policy = data.aws_iam_policy_document.static_website.json
# }

# data "aws_iam_policy_document" "static_website" {
#   statement {
#     effect = "Allow"

#     actions = [
#       "s3:GetObject"
#     ]

#     resources = [
#       aws_s3_bucket.foo.arn,
#       "${aws_s3_bucket.foo.arn}/*",
#     ]

#     principals {
#       type        = "AWS"
#       identifiers = ["*"]
#     }
#   }
# }
