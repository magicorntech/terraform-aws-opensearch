resource "aws_security_group" "main" {
  name        = "${var.tenant}-${var.name}-es-${var.search_name}-sg-${var.environment}"
  description = "Managed by Magicorn"
  vpc_id      = var.vpc_id

  ingress {
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = [var.cidr_block]
  }

  dynamic "ingress" {
    for_each = (var.additional_ips != null) ? [true] : []
    content {
      protocol    = "tcp"
      from_port   = 443
      to_port     = 443
      cidr_blocks = var.additional_ips
    }
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name        = "${var.tenant}-${var.name}-es-${var.search_name}-sg-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
