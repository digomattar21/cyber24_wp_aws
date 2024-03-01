resource "aws_internet_gateway" "example" {
  vpc_id = aws_vpc.my_vpc.id
}