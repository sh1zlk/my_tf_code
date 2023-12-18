resource "aws_s3_bucket" "main" {
  bucket = "front-shop-bucket"

  tags = {
    Name        = "My bucket"
    Environment = "Dev"
  }
}


resource "aws_s3_bucket_acl" "b_acl" {
  bucket = aws_s3_bucket.main.id
  acl = true
}