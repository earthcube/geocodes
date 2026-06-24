# ── S3 bucket ──────────────────────────────────────────────────────────────────

locals {
  s3_bucket_name = var.s3_bucket_name != "" \
    ? var.s3_bucket_name \
    : "${var.project_name}-geocodes-${data.aws_caller_identity.current.account_id}"
}

resource "aws_s3_bucket" "geocodes" {
  bucket        = local.s3_bucket_name
  force_destroy = false

  tags = {
    Name    = local.s3_bucket_name
    Project = var.project_name
  }
}

resource "aws_s3_bucket_versioning" "geocodes" {
  bucket = aws_s3_bucket.geocodes.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_lifecycle_configuration" "geocodes" {
  bucket = aws_s3_bucket.geocodes.id

  rule {
    id     = "expire-noncurrent"
    status = "Enabled"
    noncurrent_version_expiration {
      noncurrent_days = 30
    }
  }
}

# Allow public read for graphs/latest/* so Qlever can download release files
# via plain HTTP (no AWS credentials needed in the Qleverfile GET_DATA_CMD).
# Set s3_graphs_public = false and use aws s3 presign or AWS CLI with
# credentials in GET_DATA_CMD if your data must remain private.

resource "aws_s3_bucket_public_access_block" "geocodes" {
  bucket = aws_s3_bucket.geocodes.id

  block_public_acls       = true
  block_public_policy     = !var.s3_graphs_public
  ignore_public_acls      = true
  restrict_public_buckets = !var.s3_graphs_public
}

resource "aws_s3_bucket_policy" "geocodes" {
  count  = var.s3_graphs_public ? 1 : 0
  bucket = aws_s3_bucket.geocodes.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        # Public read for Qlever index download
        Sid       = "PublicReadGraphsLatest"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.geocodes.arn}/graphs/latest/*"
      },
      {
        # Full access for the geocodes IAM user
        Sid       = "GeocodesUserFullAccess"
        Effect    = "Allow"
        Principal = { AWS = aws_iam_user.geocodes.arn }
        Action    = "s3:*"
        Resource = [
          aws_s3_bucket.geocodes.arn,
          "${aws_s3_bucket.geocodes.arn}/*"
        ]
      }
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.geocodes]
}

# ── IAM user for scheduler / Dagster ──────────────────────────────────────────
# These credentials go into the .env file on the EC2 instance.

resource "aws_iam_user" "geocodes" {
  name = "${var.project_name}-geocodes-scheduler"
  path = "/geocodes/"

  tags = {
    Project = var.project_name
  }
}

resource "aws_iam_user_policy" "geocodes_s3" {
  name = "${var.project_name}-geocodes-s3"
  user = aws_iam_user.geocodes.name

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Effect = "Allow"
        Action = [
          "s3:GetObject",
          "s3:PutObject",
          "s3:DeleteObject",
          "s3:ListBucket",
          "s3:GetBucketLocation",
          "s3:ListBucketMultipartUploads",
          "s3:AbortMultipartUpload",
          "s3:ListMultipartUploadParts"
        ]
        Resource = [
          aws_s3_bucket.geocodes.arn,
          "${aws_s3_bucket.geocodes.arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_access_key" "geocodes" {
  user = aws_iam_user.geocodes.name
}
