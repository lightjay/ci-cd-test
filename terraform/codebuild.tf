//resource "aws_codebuild_project" "tf_runner" {
//  name          = "${local.app_name}-tf-runner"
//  description   = "TF runner for ${aws_codepipeline.pipeline.name} pipeline"
//  build_timeout = "5"
//  service_role  = aws_iam_role.example.arn
//
//  artifacts {
//    type = "NO_ARTIFACTS"
//  }
//
//  environment {
//    compute_type                = "BUILD_GENERAL1_SMALL"
//    image                       = "aws/codebuild/standard:1.0"
//    type                        = "LINUX_CONTAINER"
//    image_pull_credentials_type = "CODEBUILD"
//  }
//
//  logs_config {
//    cloudwatch_logs {
//      group_name  = aws_cloudwatch_log_group.codepipeline.name
//    }
//  }
//
//  source {
//    type            = "NO_SOURCE"
//    buildspec       = data.template_file.codebuild_buildspec.rendered
//  }
//
//  tags = {
//    AppName = local.app_name
//  }
//}
//
//
//resource "aws_s3_bucket" "example" {
//  bucket = "example"
//  acl    = "private"
//}
//
//resource "aws_iam_role" "example" {
//  name = "example"
//
//  assume_role_policy = <<EOF
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Principal": {
//        "Service": "codebuild.amazonaws.com"
//      },
//      "Action": "sts:AssumeRole"
//    }
//  ]
//}
//EOF
//}
//
//resource "aws_iam_role_policy" "example" {
//  role = aws_iam_role.example.name
//
//  policy = <<POLICY
//{
//  "Version": "2012-10-17",
//  "Statement": [
//    {
//      "Effect": "Allow",
//      "Resource": [
//        "*"
//      ],
//      "Action": [
//        "logs:CreateLogGroup",
//        "logs:CreateLogStream",
//        "logs:PutLogEvents"
//      ]
//    },
//    {
//      "Effect": "Allow",
//      "Action": [
//        "ec2:CreateNetworkInterface",
//        "ec2:DescribeDhcpOptions",
//        "ec2:DescribeNetworkInterfaces",
//        "ec2:DeleteNetworkInterface",
//        "ec2:DescribeSubnets",
//        "ec2:DescribeSecurityGroups",
//        "ec2:DescribeVpcs"
//      ],
//      "Resource": "*"
//    },
//    {
//      "Effect": "Allow",
//      "Action": [
//        "ec2:CreateNetworkInterfacePermission"
//      ],
//      "Resource": [
//        "arn:aws:ec2:us-east-1:123456789012:network-interface/*"
//      ],
//      "Condition": {
//        "StringEquals": {
//          "ec2:Subnet": [
//            "${aws_subnet.example1.arn}",
//            "${aws_subnet.example2.arn}"
//          ],
//          "ec2:AuthorizedService": "codebuild.amazonaws.com"
//        }
//      }
//    },
//    {
//      "Effect": "Allow",
//      "Action": [
//        "s3:*"
//      ],
//      "Resource": [
//        "${aws_s3_bucket.example.arn}",
//        "${aws_s3_bucket.example.arn}/*"
//      ]
//    }
//  ]
//}
//POLICY
//}
//
//resource "aws_codebuild_project" "project-with-cache" {
//  name           = "test-project-cache"
//  description    = "test_codebuild_project_cache"
//  build_timeout  = "5"
//  queued_timeout = "5"
//
//  service_role = aws_iam_role.example.arn
//
//  artifacts {
//    type = "NO_ARTIFACTS"
//  }
//
//  cache {
//    type  = "LOCAL"
//    modes = ["LOCAL_DOCKER_LAYER_CACHE", "LOCAL_SOURCE_CACHE"]
//  }
//
//  environment {
//    compute_type                = "BUILD_GENERAL1_SMALL"
//    image                       = "aws/codebuild/standard:1.0"
//    type                        = "LINUX_CONTAINER"
//    image_pull_credentials_type = "CODEBUILD"
//
//    environment_variable {
//      name  = "SOME_KEY1"
//      value = "SOME_VALUE1"
//    }
//  }
//
//  source {
//    type            = "GITHUB"
//    location        = "https://github.com/mitchellh/packer.git"
//    git_clone_depth = 1
//  }
//
//  tags = {
//    Environment = "Test"
//  }
//}