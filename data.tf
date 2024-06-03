data "aws_caller_identity" "current" {}
data "aws_region" "current" {}

resource "random_string" "user" {
  length  = 10
  numeric = false
  special = false
}

resource "random_password" "pass" {
  length      = 16
  special     = true
  min_upper   = 3
  min_lower   = 3
  min_numeric = 3
  min_special = 1
}