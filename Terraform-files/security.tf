
resource "aws_security_group" "web_sg" {
  name        = "${var.project}-web-sg"
  description = "Allow HTTP (and optional SSH)"
  vpc_id      = aws_vpc.main.id

  # HTTP
  ingress {
    description = "HTTP"
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    #cidr_blocks = ["0.0.0.0/0"]
    cidr_blocks = ["117.20.20.35/32"]
  }


  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
    
  }

  tags = {
    Name = "${var.project}-web-sg"
  }
}
