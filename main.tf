provider "aws" {

}

resource "aws_instance" "ubuntu" {
  count         = 1
  ami           = "ami-0a634ae95e11c6f91"
  instance_type = "t2.micro"

}

resource "aws_instance" "windows" {
  count         = 1
  ami           = "ami-029e27fb2fc8ce9d8"
  instance_type = "t2.micro"

}
