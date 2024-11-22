resource "aws_iam_role" "github_actions_role" {
  name = "${var.project_prefix}_iam_github_actions_role"

  assume_role_policy = jsonencode({
    Version = "2012-10-17",
    Statement = [
      {
        Effect = "Allow",
        Principal = {
          Federated = var.github_oidc_provider_arn
        },
        Action = "sts:AssumeRoleWithWebIdentity",
        Condition = {
          StringEquals = {
            "token.actions.githubusercontent.com:aud" = "sts.amazonaws.com"
          },
          StringLike = {
            "token.actions.githubusercontent.com:sub" = "repo:${var.github_username}/${var.github_repo_name}:*"
          }
        }
      }
    ]
  })

  tags = {
    Name = "${var.project_prefix}_iam_github_actions_role"
  }
}

resource "aws_iam_policy" "github_actions_policy" {
  name        = "${var.project_prefix}_github_actions_policy"
  description = "Policy to grant least privilege access for deploying Lambda functions from GitHub Actions"
  policy = jsonencode({
    "Version" : "2012-10-17",
    "Statement" : [
      {
        "Effect" : "Allow",
        "Action" : [
          # S3
          "s3:GetObject",
          "s3:PutObject",
          "s3:ListBucket",
        ],
        # These are outputs from the s3 remote state
        "Resource" : [
          "${data.terraform_remote_state.s3["dev"].outputs.s3_bucket_arn}",
          "${data.terraform_remote_state.s3["dev"].outputs.s3_bucket_arn}/*",
          "${data.terraform_remote_state.s3["prod"].outputs.s3_bucket_arn}",
          "${data.terraform_remote_state.s3["prod"].outputs.s3_bucket_arn}/*"
        ]
      }
    ]
  })
}

resource "aws_iam_role_policy_attachment" "attach_github_lambda_policy" {
  role       = aws_iam_role.github_actions_role.name
  policy_arn = aws_iam_policy.github_actions_policy.arn
}
