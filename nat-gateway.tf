# NAT gateway
resource "aws_nat_gateway" "natgw" {
  count         = var.is_multiple_ngw ? length(local.vpc_public_subnets) : length(local.vpc_public_subnets)  > 0 ? 1 : 0
  allocation_id = element(aws_eip.ip.*.id, count.index)
  subnet_id     = element(aws_subnet.public.*.id,count.index)

  tags = merge(
    { 
      Name       = "${local.vpc_name}-natgw"
    },
    local.default_tags
  )
}
