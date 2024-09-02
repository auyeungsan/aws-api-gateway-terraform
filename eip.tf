# Elastic IP
resource "aws_eip" "ip" {
  count = var.is_multiple_ngw ?  length(local.vpc_private_subnets) : length(local.vpc_private_subnets)  > 0 ? 1 : 0
  domain = "vpc"
  tags = merge(
    {
        Name = "${local.vpc_name}-natgw-elasticIP"
    },
    local.default_tags
  )
}
