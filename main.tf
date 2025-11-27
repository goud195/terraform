provider "aws" {
  region = "us-east-1"
}

module "data_library_lambda" {
  source      = "./module/lambda"
  environment = var.environment

  # optional overrides, or you just use defaults in module
  # runtime  = "python3.9"
  # handler  = "index.handler"
}
