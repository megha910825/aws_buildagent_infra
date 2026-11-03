resource "aws_security_group" "ba_sg" {
  name        = "ba-sg"
  description = "Security group for build agents - no inbound, outbound only"
  vpc_id      = var.ba_vpc_id

  egress {
    description = "Allow all outbound"
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "ba-sg"
  }
}
