resource "aws_security_group" "wazuh_sg" {
  vpc_id = aws_vpc.my_vpc.id


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

resource "aws_key_pair" "wazuh" {
  key_name   = "wazuh"
  public_key = file("~/Desktop/cyberElet/wazuh.pub")
}

resource "aws_instance" "wazuh" {
  ami           = "ami-0cf1810907a781f00" # Ubuntu 22.04 us-east-1
  instance_type = "t2.medium"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.wazuh_sg.id]
  key_name = aws_key_pair.wazuh.key_name
  
  user_data = <<-EOF
            #!/bin/bash
            sudo apt update
            EOF

  tags = {
    Name = "Wazuh"
  }
}
