resource "aws_codepipeline" "pipeline" {
  name     = local.app_name
  role_arn = aws_iam_role.codepipeline_role.arn

  artifact_store {
    location = aws_s3_bucket.pipeline_artifacts.bucket
    type     = "S3"
  }

  tags = {
    AppName = local.app_name
  }

  stage {
    name = "Source"

    action {
      name             = "Source"
      category         = "Source"
      owner            = "AWS"
      provider         = "CodeStarSourceConnection"
      version          = "1"
      output_artifacts = ["source_output"]

      configuration = {
        ConnectionArn    = aws_codestarconnections_connection.pipeline.arn
        FullRepositoryId = "lightjay/ci-cd-test"
        BranchName       = "main"
      }
    }
  }

  stage {
    name = "TerraformApply"

    action {
      name             = "TerraformApply"
      category         = "Build"
      owner            = "AWS"
      provider         = "CodeBuild"
      input_artifacts  = ["source_output"]
      output_artifacts = ["tf_output"]
      version          = "1"

      configuration = {
        ProjectName = "test"
      }
    }
  }
}

resource "aws_codestarconnections_connection" "pipeline" {
  name          = "${local.app_name}-connection"
  provider_type = "GitHub"
}


resource "aws_iam_role" "codepipeline_role" {
  name = "${local.app_name}-codepipeline-role"

  assume_role_policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "Service": "codepipeline.amazonaws.com"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
EOF
}

resource "aws_iam_role_policy" "codepipeline_policy" {
  name = "${local.app_name}-codepipeline-policy"
  role = aws_iam_role.codepipeline_role.id

  policy = <<EOF
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect":"Allow",
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
      "Effect": "Allow",
      "Action": [
        "codebuild:BatchGetBuilds",
        "codebuild:StartBuild"
      ],
      "Resource": "*"
    },
    {
      "Effect": "Allow",
      "Action": [
        "codestar-connections:UseConnection"
      ],
      "Resource": "${aws_codestarconnections_connection.pipeline.arn}"
    }
  ]
}
EOF
}

//resource "aws_cloudwatch_log_group" "codepipeline" {
//  name  = "/aws/codepipeline/${aws_codepipeline.pipeline.name}"
//  retention_in_days = 30
//  tags = {
//    AppName = local.app_name
//  }
//}