
module "lambda_functions" {
  source      = "./modules/lambda"   # folder where your module code is
  environment = var.environment     # dev / test / uat
}
