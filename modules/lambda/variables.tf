abc
variable "environment" {
  type = string
}

# Payment lambda policies
variable "payment_aws_policy_arn" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/CloudWatchLogsFullAccess",
    "arn:aws:iam::aws:policy/AmazonDynamoDBFullAccess",
    "arn:aws:iam::aws:policy/AWSStepFunctionsFullAccess",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
}

# User lambda policies
variable "user_policy" {
  type = list(string)
  default = [
    "arn:aws:iam::aws:policy/AmazonWorkSpacesAdmin",
    "arn:aws:iam::aws:policy/AmazonSSMReadOnlyAccess"
  ]
}

# (optional) runtime/handler if you want to override from root in future
variable "runtime" {
  type    = string
  default = "python3.9"
}

variable "handler" {
  type    = string
  default = "index.handler"
}
