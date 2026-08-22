data "aws_iam_policy_document" "github_trust" {
  statement {
    effect = "Allow"


    actions = [
      "sts:AssumeRoleWithWebIdentity"
    ]

    principals {
      type = "Federated"

      identifiers = [
        aws_iam_openid_connect_provider.github.arn
      ]
    }

    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:aud"

      values = [
        "sts.amazonaws.com"
      ]
    }
    condition {
      test     = "StringEquals"
      variable = "token.actions.githubusercontent.com:sub"

      values = [
        "repo:${var.github_owner}/${var.github_repository}:pull_request",
        "repo:${var.github_owner}/${var.github_repository}:ref:refs/heads/main"
      ]
    }

  }
}


resource "aws_iam_role" "terraform_plan" {
  name               = "github-projects-terraform-plan"
  assume_role_policy = data.aws_iam_policy_document.github_trust.json
}


data "aws_iam_policy_document" "terraform_plan_permissions" {
  statement {
    effect = "Allow"

    actions = [
      "ec2:DescribeAvailabilityZones"
    ]
    resources = ["*"]
  }
}


resource "aws_iam_role_policy" "terraform_plan" {
  name   = "terraform-plan-minimum-access"
  role   = aws_iam_role.terraform_plan.id
  policy = data.aws_iam_policy_document.terraform_plan_permissions.json

}