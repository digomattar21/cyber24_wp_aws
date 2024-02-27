resource "aws_security_group" "mysql_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
    cidr_blocks = [aws_security_group.wordpress_sg.id]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "mysql" {
  ami           = "ami-0cf1810907a781f00" #Ubuntu 22.04 us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.private_subnet.id
  security_groups = [aws_security_group.mysql_sg.name]

  user_data = <<-EOF
              #!/bin/bash
              sudo apt update
              sudo apt install -y mysql-server
              #Secure MySQL installation (this is a placeholder, you'll need to customize this part)
              sudo mysql_secure_installation
              Create your database and user
              sudo mysql -e "CREATE DATABASE wordpress;"
              sudo mysql -e "CREATE USER '${db_user}'@'%' IDENTIFIED BY '${db_password}';"
              sudo mysql -e "GRANT ALL PRIVILEGES ON wordpress.* TO '${db_user}'@'%';"
              sudo mysql -e "FLUSH PRIVILEGES;"
              EOF


  tags = {
    Name = "MySQL"
  }
}