resource "aws_opensearch_domain" "main" {
  domain_name    = "${var.tenant}-${var.name}-${var.search_name}-${var.environment}"
  engine_version = var.engine_version

  cluster_config {
    instance_count           = var.instance_count
    instance_type            = var.instance_type
    dedicated_master_enabled = false
    warm_enabled             = false
    zone_awareness_enabled   = var.zone_awareness

    dynamic "zone_awareness_config" {
      for_each = (var.zone_awareness == true) ? [2] : []
      content {
        availability_zone_count = zone_awareness_config.value
      }
    }
  }

  auto_tune_options {
    desired_state       = "DISABLED"
    rollback_on_disable = "NO_ROLLBACK"
  }

  advanced_security_options {
    enabled                        = false
    internal_user_database_enabled = false
  }

  domain_endpoint_options {
    enforce_https       = true
    tls_security_policy = "Policy-Min-TLS-1-2-2019-07"
  }

  vpc_options {
    subnet_ids         = (var.zone_awareness == true) ? [var.subnet_ids[0], var.subnet_ids[1]] : [var.subnet_ids[0]]
    security_group_ids = [aws_security_group.main.id]
  }

  ebs_options {
    ebs_enabled = true
    volume_size = var.volume_size
    volume_type = var.volume_type
  }

  encrypt_at_rest {
    enabled    = (var.encryption == true) ? true : false
    kms_key_id = (var.encryption == true) ? var.kms_key_id : null
  }

  node_to_node_encryption {
    enabled = true
  }

  advanced_options = {
    "rest.action.multi.allow_explicit_index" = "true"
  }

  access_policies = <<CONFIG
{
    "Version": "2012-10-17",
    "Statement": [
        {
            "Action": "es:*",
            "Principal": {
              "AWS": "*"
            },
            "Effect": "Allow",
            "Resource": "arn:aws:es:${data.aws_region.current.name}:${data.aws_caller_identity.current.account_id}:domain/${var.tenant}-${var.name}-${var.search_name}-${var.environment}/*"
        }
    ]
}
CONFIG

  tags = {
    Name        = "${var.tenant}-${var.name}-${var.search_name}-${var.environment}"
    Tenant      = var.tenant
    Project     = var.name
    Environment = var.environment
    Maintainer  = "Magicorn"
    Terraform   = "yes"
  }
}
