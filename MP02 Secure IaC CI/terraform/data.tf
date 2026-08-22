data "aws_caller_identity" "current" {}

data "aws_availability_zone" "available" {
  state = available
}

