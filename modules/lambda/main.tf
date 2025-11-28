data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

#################### account id and region  ##########################
locals {
  account_id = data.aws_caller_identity.current.account_id
  aws_region = data.aws_region.current.id   # was .name (deprecated)
}

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

  #  path.module so it looks in modules/lambda
  filename         = "${path.module}/lambda_dummy.zip"
  # (optional but good)
  # source_code_hash = filebase64sha256("${path.module}/lambda_dummy.zip")

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


  filename         = "${path.module}/lambda_dummy.zip"
  # source_code_hash = filebase64sha256("${path.module}/lambda_dummy.zip")

  timeout     = 10
  memory_size = 128
}
   