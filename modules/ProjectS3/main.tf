resource "aws_s3_bucket" "qualitybucket" {
  bucket        = "${var.bucket_name}bucket"
  force_destroy = true
  tags =  { Name = "${var.pName}-Bucket" }

}

resource "aws_s3_bucket_policy" "bucket_pol" {
  bucket = aws_s3_bucket.qualitybucket.bucket

  
  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicRead"
        Effect    = "Allow"
        Principal = "*"
        Action    = [
                    "s3:GetObject",
                    "s3:GetObjectVersion"
                    ]
        Resource = "${aws_s3_bucket.qualitybucket.arn}/*"
      },
    ]
  })
}

resource "aws_s3_bucket_acl" "bucket_acl" {
  bucket = aws_s3_bucket.qualitybucket.bucket
  acl    = "private"
}