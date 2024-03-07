resource "aws_eip" "my_instance_eip" {
  instance = aws_instance.wordpress_1.id

  tags = {
    Name = "Wordpress Instance"
  }
}

resource "aws_eip" "nat_eip" {
  vpc = true
}
