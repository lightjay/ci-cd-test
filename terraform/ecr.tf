resource "aws_ecr_repository" "cicd-test" {
  name                 = local.app_name
  image_tag_mutability = "MUTABLE"

  image_scanning_configuration {
    scan_on_push = true
  }
}

resource "aws_iam_user" "gitlab_ci_ecr" {
  name = "gitlab_ci_ecr_user"
}

resource "aws_iam_user_policy_attachment" "test-attach" {
  user       = aws_iam_user.gitlab_ci_ecr.name
  policy_arn = "arn:aws:iam::aws:policy/AmazonEC2ContainerRegistryPowerUser"
}