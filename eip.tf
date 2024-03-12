resource "aws_eip" "example_eip" {
  vpc = true 
}

resource "aws_eip_association" "eip_assoc" {
  instance_id   = aws_instance.wordpress.id
  allocation_id = aws_eip.example_eip.id
}

resource "aws_eip" "nat_eip" {
  vpc = true
}
