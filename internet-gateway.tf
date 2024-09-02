# Internet Gateway
resource "aws_internet_gateway" "cluster_int_gw" {
   vpc_id = aws_vpc.starrise_dev_clustervpc_v1.id
   tags = merge(
      { 
         Name        = "${local.vpc_name}-intgw"
      },
      local.default_tags
   )
}