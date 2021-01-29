resource "aws_codebuild_project" "tf_runner" {
  name          = "${local.app_name}-tf-runner"
  description   = "TF runner for ${aws_codepipeline.pipeline.name} pipeline"
  build_timeout = "5"
  service_role  = aws_iam_role.codebuild_terraform.arn

  artifacts {
    type = "NO_ARTIFACTS"
  }

  environment {
    compute_type                = "BUILD_GENERAL1_SMALL"
    image                       = "hashicorp/terraform:0.13.6"
    type                        = "LINUX_CONTAINER"
    image_pull_credentials_type = "CODEBUILD"
  }

  logs_config {
    cloudwatch_logs {
      group_name  = aws_cloudwatch_log_group.codepipeline.name
    }
  }

  source {
    type            = "NO_SOURCE"
    buildspec       = data.template_file.codebuild_buildspec.rendered
  }

  tags = {
    AppName = local.app_name
  }
}


//resource "aws_s3_bucket" "example" {
//  bucket = "example"
//  acl    = "private"
//}
//
resource "aws_iam_role" "codebuild_terraform" {
  name = "codebuild_terraform"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codebuild.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codebuild_terraform" {
  role = aws_iam_role.codebuild_terraform.name

  policy = <<POLICY
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Resource": [ "*" ],
      "Action": [ "*" ]
    }
  ]
}
POLICY
}
