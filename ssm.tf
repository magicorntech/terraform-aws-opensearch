resource "aws_ssm_parameter" "main_es_user" {
  name        = "/${var.tenant}/${var.name}/${var.environment}/es/${var.search_name}/user"
  description = "Managed by Magicorn"
  type        = "SecureString"
  value       = random_string.user.result

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.environment}-es-${var.search_name}-port"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}

resource "aws_ssm_parameter" "main_es_pass" {
  name        = "/${var.tenant}/${var.name}/${var.environment}/es/${var.search_name}/pass"
  description = "Managed by Magicorn"
  type        = "SecureString"
  value       = random_password.pass.result

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.environment}-es-${var.search_name}-port"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}