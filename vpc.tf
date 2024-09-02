resource "aws_vpc" "starrise_dev_clustervpc_v1" {
  cidr_block            = local.vpc_cidr
  instance_tenancy      = local.vpc_instance_tenancy
  enable_dns_hostnames  = true
  enable_dns_support    = true
  
  tags = merge(
      {
         Name = "${local.vpc_name}"
      },
      local.default_tags
  )
}

# Publiс subnet
resource "aws_subnet" "public" {
   count             = length(local.vpc_public_subnets)
   vpc_id            = aws_vpc.starrise_dev_clustervpc_v1.id
   cidr_block        = element(local.vpc_public_subnets ,count.index)
   availability_zone = element(local.vpc_azs,count.index)
   enable_resource_name_dns_a_record_on_launch = true
   map_public_ip_on_launch = true

   tags = merge(
      { 
         Name           = "${local.vpc_name}-public-${element(local.vpc_azs,count.index)}"
         "kubernetes.io/role/elb" = "1"
         "tier" = "public"
      },
      local.default_tags
   )
}

# Private subnet
resource "aws_subnet" "private" {
   count             = length(local.vpc_private_subnets)
   vpc_id            = aws_vpc.starrise_dev_clustervpc_v1.id
   cidr_block        = element(local.vpc_private_subnets,count.index)
   availability_zone = element(local.vpc_azs,count.index)
   enable_resource_name_dns_a_record_on_launch = true
   
   tags = merge(
      {
         Name           = "${local.vpc_name}-private-${element(local.vpc_azs,count.index)}"
         "karpenter.sh/discovery"          = "starrise-dev-cluster-v1"
         "kubernetes.io/role/internal-elb" = "1"
         "tier" = "private"
      },
      local.default_tags
   )
}

//Publiс routes
resource "aws_route_table" "public" {
   count    = length(local.vpc_public_subnets) > 0 ? 1 : 0
   vpc_id   = aws_vpc.starrise_dev_clustervpc_v1.id

   tags = merge(
      {
         Name        = "${local.vpc_name}-public"
      },
      local.default_tags
   )
}


# Private routes
resource "aws_route_table" "private" {
   count     = var.is_multiple_private_routetable ? length(local.vpc_private_subnets) : length(local.vpc_private_subnets) > 0 ? 1 : 0
   vpc_id    = aws_vpc.starrise_dev_clustervpc_v1.id

   tags = merge(
      { 
         Name       =  "${local.vpc_name}-private-${element(local.vpc_azs,count.index)}"
      },
      local.default_tags
   )
}

# Private NAT gw routes
resource "aws_route" "private_nat_gateway" {
   count                  = length(local.vpc_private_subnets)

   route_table_id         = element(aws_route_table.private.*.id, count.index)
   destination_cidr_block = "0.0.0.0/0"
   nat_gateway_id             = element(aws_nat_gateway.natgw.*.id, count.index)
   # tags = {
   #    Name        = "${local.vpc_name}-private"
   # }
}

# Public int gw routes
resource "aws_route" "public_internet_gateway" {
   count                  = length(local.vpc_public_subnets) > 0 ? 1 : 0

   route_table_id         = element(aws_route_table.public.*.id, count.index)
   destination_cidr_block = "0.0.0.0/0"
   gateway_id             = aws_internet_gateway.cluster_int_gw.id
   # tags = {
   #    Name        = "${local.vpc_name}-public"
   # }
}


# Public Route table association
resource "aws_route_table_association" "public" {
  count           = length(local.vpc_public_subnets)
  subnet_id       = element(aws_subnet.public.*.id, count.index)
  route_table_id  = element(aws_route_table.public.*.id, count.index)
}

# Private Route table association
resource "aws_route_table_association" "private" {
   count          = length(local.vpc_private_subnets)
   subnet_id      = element(aws_subnet.private.*.id, count.index)
   route_table_id = element(aws_route_table.private.*.id, count.index)
}