#### Provider ####
provider "aws" {
  region = "us-east-2"
}

#### Resources ####
resource "aws_instance" "example" {
  ami           = "ami-0c55b159cbfafe1f0" # Amazon Linux 2 AMI (HVM), SSD Volume Type
  instance_type = "t3.micro"

  tags = {
    Name = "ExampleInstance"
  }
}