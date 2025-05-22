resource "aws_internet_gateway" "logistics-igw" {
  vpc_id = aws_vpc.logstic_vpc.id

  tags = {
    Name        = "${var.project}-${var.environment}-igw"
    Environment = var.environment
  }
}

resource "aws_eip" "nat_eip" {
  domain = "vpc"

  tags = {
    Name        = "${var.project}-${var.environment}-nat-eip"
    Environment = var.environment
  }
}

resource "aws_nat_gateway" "nat_gw" {
  allocation_id = aws_eip.nat_eip.id
  subnet_id     = aws_subnet.logistics_public_subnet[0].id

  tags = {
    Name        = "${var.project}-${var.environment}-nat-gw"
    Environment = var.environment
  }

  depends_on = [aws_internet_gateway.logistics-igw]
}
