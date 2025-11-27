data aws_caller_identity current {
}

data "aws_region" "current" {}

#################### account id and region  ##########################
locals {
 account_id          = data.aws_caller_identity.current.account_id
 aws_region = data.aws_region.current.name
}

#########################################################


locals {
  env = var.environment
}

# ============================
# USER LAMBDA: IAM ROLE + POL
# ============================

resource "aws_iam_role" "user_role" {
  name = "user-lambda-role-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })
}

# Attach each managed policy in user_policy list
resource "aws_iam_role_policy_attachment" "user_managed_policies" {
  for_each   = toset(var.user_policy)
  role       = aws_iam_role.user_role.name
  policy_arn = each.value
}

resource "aws_lambda_function" "user_lambda" {
  function_name = "user-lambda-${local.env}"
  role          = aws_iam_role.user_role.arn
  runtime       = var.runtime
  handler       = var.handler

  filename         = "user-lambda-${local.env}.zip"
  source_code_hash = filebase64sha256("user-lambda-${local.env}.zip")

  timeout     = 10
  memory_size = 128
}

# =================================
# PAYMENT LAMBDA: IAM ROLE + POL
# =================================

resource "aws_iam_role" "payment_role" {
  name = "payment-lambda-role-${local.env}"

  assume_role_policy = jsonencode({
    Version = "2012-10-17"
    Statement = [{
      Effect = "Allow"
      Principal = { Service = "lambda.amazonaws.com" }
      Action   = "sts:AssumeRole"
    }]
  })
}

# Attach each managed policy in payment_aws_policy_arn list
resource "aws_iam_role_policy_attachment" "payment_managed_policies" {
  for_each   = toset(var.payment_aws_policy_arn)
  role       = aws_iam_role.payment_role.name
  policy_arn = each.value
}

resource "aws_lambda_function" "payment_lambda" {
  function_name = "payment-lambda-${local.env}"
  role          = aws_iam_role.payment_role.arn
  runtime       = var.runtime
  handler       = var.handler

  filename         = "payment-lambda-${local.env}.zip"
  source_code_hash = filebase64sha256("payment-lambda-${local.env}.zip")

  timeout     = 10
  memory_size = 128
}
