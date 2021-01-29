data "aws_caller_identity" "current" {}

resource "aws_s3_bucket" "pipeline_artifacts" {
  bucket = "codepipeline-${local.region}-${data.aws_caller_identity.current.account_id}"
  acl = "private"

  versioning {
    enabled = true
  }
}

resource "aws_s3_bucket_policy" "pipeline_artifacts" {
  bucket = aws_s3_bucket.pipeline_artifacts.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Id": "CodePipelineAccess",
  "Statement": [
    {
      "Sid": "CodePipelineAccess",
      "Effect": "Allow",
      "Principal": {
        "AWS": "${aws_iam_role.codepipeline_role.arn}"
      },
      "Action": [
        "s3:GetObject",
        "s3:GetObjectVersion",
        "s3:GetBucketVersioning",
        "s3:PutObject"
      ],
      "Resource": [
        "${aws_s3_bucket.pipeline_artifacts.arn}",
        "${aws_s3_bucket.pipeline_artifacts.arn}/*"
      ]
    },
    {
      "Sid": "DenyUnEncryptedObjectUploads",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:PutObject",
      "Resource": "${aws_s3_bucket.pipeline_artifacts.arn}/*",
      "Condition": {
          "StringNotEquals": {
              "s3:x-amz-server-side-encryption": "aws:kms"
          }
      }
    },
    {
      "Sid": "DenyInsecureConnections",
      "Effect": "Deny",
      "Principal": "*",
      "Action": "s3:*",
      "Resource": "${aws_s3_bucket.pipeline_artifacts.arn}/*",
      "Condition": {
          "Bool": {
              "aws:SecureTransport": "false"
          }
      }
    }
  ]
}
EOF
}
