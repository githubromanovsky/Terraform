provider "aws" {
  profile = "default" //secrets in profile ~/<user>/.aws
  region  = "us-east-2"
  version = "~> 3.4.0"
}


resource "aws_key_pair" "host_ubuntu" {
  key_name   = "my_key"
  public_key = file("~/.ssh/id_rsa.pub") //Your public_key

}
resource "aws_instance" "web" {
  ami                    = "ami-0dd9f0e7df0f0a138"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.my_sg.id]
  key_name               = "my_key"
  tags = {
    Name = "ubuntu"
  }

  connection {
    type        = "ssh"
    user        = "ubuntu"
    private_key = file("~/.ssh/id_rsa")
    timeout     = "2m"
    agent       = false
    host        = self.public_ip
  }
  provisioner "remote-exec" {
    inline = ["sudo apt updte && sudo apt install -y git"]
  }
}
resource "aws_eip" "ip" {
  instance = aws_instance.web.id
}

/*resource "aws_cloudwatch_metric_alarm" "billing" {
  alarm_name                = "billing"
  comparison_operator       = "GreaterThanOrEqualToThreshold"
  evaluation_periods        = "2"
  metric_name               = "biling
  namespace                 = "AWS/EC2"
  period                    = "120"
  statistic                 = "Average"
  threshold                 = "1"
  alarm_description         = "This metric monitors billing_cycle"
  insufficient_data_actions = []

  module "cost_mgmt_notif" {
  source                = "../../cost-mgmt-budget-notif-bb"

  aws_env               = "${var.aws_profile}"
  currency              = "USD"
  limit_amount          = 500
  time_unit             = "MONTHLY"
  time_period_start     = "2019-01-01_00:00"
  time_period_end       = "2019-12-31_23:59"
  aws_sns_topic_arn     = "arn:aws:lambda:us-east-1:111111111111:function:bb-root-org-notify_slack"
}

output "sns_topic" {
  value = "${module.cost_mgmt_notif.sns_topic}"
}
}*/
