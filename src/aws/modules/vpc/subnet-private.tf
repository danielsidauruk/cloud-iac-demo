resource "aws_subnet" "private" {

  for_each = local.private_subnets

  vpc_id            = aws_vpc.main.id
  availability_zone = each.value.availability_zone
  cidr_block        = each.value.cidr_block

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-private-subnet"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_eip" "nat" {
  for_each = local.private_subnets

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-eip"
    application = var.application_name
    environment = var.environment_name
  }
}

resource "aws_nat_gateway" "nat" {

  for_each = local.private_subnets

  allocation_id = aws_eip.nat[each.key].id
  subnet_id     = aws_subnet.public[each.key].id

  depends_on = [
    aws_internet_gateway.main,
  ]

  tags = {
    Name        = "${var.application_name}-${var.environment_name}-nat"
    application = var.application_name
    environment = var.environment_name
  }

}

resource "aws_route_table" "private" {

  for_each = local.private_subnets

  vpc_id = aws_vpc.main.id

  route {
    cidr_block     = "0.0.0.0/0"
    nat_gateway_id = aws_nat_gateway.nat[each.key].id
  }

}

resource "aws_route_table_association" "private" {

  for_each = local.private_subnets

  subnet_id      = aws_subnet.private[each.key].id
  route_table_id = aws_route_table.private[each.key].id

}