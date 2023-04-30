resource "aws_vpc" "main" {
  cidr_block = var.vpc_cidr_block

  enable_dns_hostnames             = var.enable_dns_hostnames
  enable_dns_support               = var.enable_dns_support
  assign_generated_ipv6_cidr_block = var.enable_ipv6
  instance_tenancy                 = var.instance_tenancy

  tags = {
    Name = "${var.vpc_name}-VPC"
  }
}

resource "aws_internet_gateway" "gw" {
  vpc_id = aws_vpc.main.id

  tags = {
    Name = "${var.vpc_name}-IG"
  }
}

resource "aws_subnet" "public_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.public_subnet_cidrs, count.index)

  tags = {
    Name = "${var.vpc_name}-public${count.index + 1}-var.azs}"
  }
}

resource "aws_subnet" "private_subnets" {
  count             = length(var.azs)
  vpc_id            = aws_vpc.main.id
  availability_zone = element(var.azs, count.index)
  cidr_block        = element(var.private_subnet_cidrs, count.index)

  tags = {
    Name = "${var.vpc_name}-private${count.index + 1}-var.azs"
  }
}

resource "aws_eip" "nat_gateways" {
  count = var.enable_nat_gateway == true ? length(aws_subnet.private_subnets) : 0
  vpc   = true
}

resource "aws_nat_gateway" "nat_gw" {
  depends_on = [
    aws_eip.nat_gateways
  ]
  count         = length(aws_subnet.private_subnets)
  allocation_id = element(aws_eip.nat_gateways, count.index).id
  subnet_id     = element(aws_subnet.private_subnets, count.index).id
}

resource "aws_route_table" "public_subnets" {
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.public_route_cidr_block
    gateway_id = aws_internet_gateway.gw.id
  }

  tags = {
    Name = "${var.vpc_name}-public route table}"
  }
}

resource "aws_route_table_association" "public_subnet_asso" {
  count          = length(aws_subnet.public_subnets)
  subnet_id      = element(aws_subnet.public_subnets[*].id, count.index)
  route_table_id = aws_route_table.public_subnets.id
}

resource "aws_route_table" "private_subnets" {
  depends_on = [
    aws_nat_gateway.nat_gw
  ]
  count  = length(aws_nat_gateway.nat_gw)
  vpc_id = aws_vpc.main.id

  route {
    cidr_block = var.private_route_cidr_block
    gateway_id = element(aws_nat_gateway.nat_gw, count.index).id
  }

  tags = {
    Name = "${var.vpc_name}-private route table"
  }
}

resource "aws_route_table_association" "private_subnet_asso" {
  count          = length(aws_subnet.private_subnets)
  subnet_id      = element(aws_subnet.private_subnets[*].id, count.index)
  route_table_id = element(aws_route_table.private_subnets[*].id, count.index)
}

#flowlog
resource "aws_flow_log" "flow_log" {
  count           = var.enable_flow_logs ? 1 : 0
  iam_role_arn    = var.flow_log_role_arn
  log_destination = var.cloudwatch_log_group
  traffic_type    = "ALL"
  vpc_id          = aws_vpc.main.id
}
