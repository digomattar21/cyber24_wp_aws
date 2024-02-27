resource "aws_security_group" "wordpress_sg" {
  vpc_id = aws_vpc.my_vpc.id

  ingress {
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
}

resource "aws_instance" "wordpress" {
  ami           = "ami-0cf1810907a781f00" # Ubuntu 22.04 us-east-1
  instance_type = "t2.micro"
  subnet_id     = aws_subnet.public_subnet.id
  security_groups = [aws_security_group.wordpress_sg.name]

  user_data = <<-EOF
            #!/bin/bash
            sudo apt update
            sudo apt install -y apache2 php php-curl php-gd php-mbstring php-xml phpxmlrpc php-soap php-intl php-zip php-mysql
            echo "<VirtualHost *:80>
                ServerAdmin webmaster@abcplace.com
                ServerName abcplace.com
                ServerAlias www.abcplace.com
                DocumentRoot /var/www/html
                ErrorLog ${APACHE_LOG_DIR}/error.log
                CustomLog ${APACHE_LOG_DIR}/access.log combined
                </VirtualHost>" | sudo tee /etc/apache2/sites-available/abcplace.conf
                
              sudo a2ensite abcplace.conf
              sudo a2dissite 000-default.conf
              sudo systemctl restart apache2
              
              # Install Certbot and request an SSL certificate for ABC Place
              sudo apt install -y software-properties-common
              sudo add-apt-repository universe
              sudo add-apt-repository ppa:certbot/certbot
              sudo apt update
              sudo apt install -y certbot python3-certbot-apache
              sudo certbot --apache -m admin@abcplace.com --domains abcplace.com,www.abcplace.com --non-interactive --agree-tos

              cd /var/www/html
              sudo wget https://wordpress.org/latest.tar.gz
              sudo tar -xzf latest.tar.gz
              sudo cp -r wordpress/* /var/www/html/
              sudo rm -rf wordpress latest.tar.gz
              sudo chown -R www-data:www-data /var/www/html
              sudo systemctl restart apache2
              EOF

  tags = {
    Name = "WordPress"
  }
}