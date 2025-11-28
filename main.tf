provider "aws" {
  region = "us-east-1"
}

module "lambda_functions" {
  source      = "./module/lambda"   # folder where your module code is
  environment = var.environment     # dev / test / uat
}
