resource "aws_security_group" "wordpress_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 443
    to_port     = 443
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    security_groups = [aws_security_group.bastion_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_key_pair" "wordpress" {
  key_name   = "wordpress"
  public_key = file("~/Desktop/cyberElet/wordpress.pub")
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0cf1810907a781f00" # Ubuntu 22.04 us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.wordpress_sg.id]
  key_name = aws_key_pair.wordpress.key_name
  
  user_data = <<-EOF
            #!/bin/bash
            sudo apt update
            sudo apt install -y apache2 php php-curl php-gd php-mbstring php-xml phpxmlrpc php-soap php-intl php-zip php-mysql
            EOF

  tags = {
    Name = "WordPress"
  }
}
