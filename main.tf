provider "aws" {
  profile = "default"
  region  = "us-east-2"
  version = "~> 3.4.0"
}
resource "aws_key_pair" "terraform" {
  key_name   = "terraform"
  public_key = file("~/.ssh/terraform.pub")

}
resource "aws_instance" "ubuntu" {
  key_name               = aws_key_pair.terraform.key_name
  ami                    = "ami-0bbe28eb2173f6167"
  instance_type          = "t2.micro"
  vpc_security_group_ids = ["sg-09d6861aa7315fe17"]
  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/terraform")
    timeout     = "2m"
    agent       = false
    host        = self.public_ip
  }
  tags = {
    Name  = "host3_ubuntu"
    owner = "-"
  }
  provisioner "local-exec" {
    command = "echo ${aws_instance.ubuntu.public_ip} > ipaddress.txt"
  }
  provisioner "remote-exec" {
    inline = ["sudo apt install -y nginx"]
  }
}
