resource "aws_iam_user" "gitlab_ci_ecr" {
  name = "gitlab_ci_ecr_user"
}

resource "aws_iam_user_policy" "cicd" {
  name = "CICDPipelineAccess"
  user = aws_iam_user.gitlab_ci_ecr.name

  policy = <<EOF
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Sid": "DevOpsPipelineAccess",
            "Action": [
                "account:*",
                "acm:*",
                "apigateway:*",
                "appmesh:Describe*",
                "appmesh:List*",
                "application-autoscaling:*",
                "appsync:*",
                "athena:*",
                "autoscaling:*",
                "aws-portal:*",
                "backup:*",
                "budgets:*",
                "cloudsearch:*",
                "ce:*",
                "cloudfront:*",
                "cloudformation:*",
                "cloudtrail:*",
                "cloudwatch:*",
                "config:*",
                "dms:*",
                "dynamodb:*",
                "ec2:CreateNetworkInterface*",
                "ec2:DeleteNetworkInterface*",
                "ec2:Describe*",
                "ecs:*",
                "elasticache:*",
                "elasticfilesystem:*",
                "elasticloadbalancing:*",
                "elastictranscoder:*",
                "es:*",
                "events:*",
                "firehose:*",
                "fms:*",
                "glue:*",
                "iam:*",
                "kinesis:*",
                "kinesisanalytics:*",
                "kinesisvideo:*",
                "kms:*",
                "lambda:*",
                "logs:*",
                "organizations:*",
                "rds:*",
                "rds-data:*",
                "redshift:*",
                "sagemaker:*",
                "s3:*",
                "secretsmanager:*",
                "sns:*",
                "sqs:*",
                "ssm:*",
                "states:*",
                "sts:*",
                "support:*",
                "transfer:*",
                "workspaces:*",
                "ecr:*",
                "codestar-connections:*",
                "codepipeline:*",
                "codebuild:*"
            ],
            "Effect": "Allow",
            "Resource": "*"
        }
    ]
}
EOF
}
