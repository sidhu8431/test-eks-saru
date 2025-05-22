resource "aws_vpc" "logstic_vpc" {
  cidr_block           = var.cidr_block
  enable_dns_hostnames = var.enable_dns_hostnames

  tags = merge(
    var.tags_common,
    {
      Name        = "${var.project}-${var.environment}-vpc"
      Environment = var.environment
    }
  )
}
