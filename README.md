# terraform-aws-opensearch

Magicorn made Terraform Module for AWS Provider
--
```
module "opensearch" {
  source         = "magicorntech/opensearch/aws"
  version        = "0.0.1"
  tenant         = var.tenant
  name           = var.name
  environment    = var.environment
  vpc_id         = var.vpc_id
  cidr_block     = var.cidr_block
  subnet_ids     = var.subnet_ids
  encryption     = true # 1
  kms_key_id     = module.kms-prod.es_key_id[0]
  additional_ips = ["10.10.6.12/32"] # should be set empty []

  # OpenSearch Configuration
  search_name    = "temporal"
  engine_version = "OpenSearch_2.11"
  instance_type  = "t3.small.search"
  instance_count = 1
  zone_awareness = false # true if instance_count > 1
  volume_type    = "gp3"
  volume_size    = 10
}
```

## Notes
1) Works better with magicorn-aws-kms module.