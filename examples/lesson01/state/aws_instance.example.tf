resource "aws_instance" "example" {
  instance_type = "t2.micro"
  ami           = "ami-7ad7c21e"
  subnet_id     = "subnet-05f8f3c120238ca8d"
  vpc_security_group_ids = [
    "sg-05749b21616ab0cdc",
  ]
}
