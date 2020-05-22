provider "aws" {
  region = "${var.region}"
}
terraform {
  backend "s3" {
    bucket = "curso-aws-terraform-remote-state-dev"
    key    = "ec2/ec2.tfstate"
    region = "us-east-1"
  }
}
resource "aws_instance" "web" {
  ami           = "${var.ami}"
  instance_type = "${var.instance_type}"
  key_name      = "${var.key_pair}"

  provisioner "file" {
    source      = "ambiente-teste.log"
    destination = "/tmp/file.log"
    connections {
      type        = "ssh"
      user        = "ec2-user"
      timeout     = "1m"
      private_key = "${file("/home/tribix/estudos/acessos/aws-aurelio.pem")}"
    }
  }
  provisioner "remote-exec" {
    inline = [
      "sleep 10",
      "sudo yum update -y",
      "sudo install -y httpd",
      "sudo service httpd start",
      "sudo chkconfig httpd on",
      "sleep 10",
    ]
    connections {
      type        = "ssh"
      user        = "ec2-user"
      timeout     = "1m"
      private_key = "${file("/home/tribix/estudos/acessos/aws-aurelio.pem")}"
    }
  }
}

resource "null_resource" "null" {
  provisioner "local-exec" {
    command = "echo ${aws_instance.web.private_ip}:${aws_instance.web.id} >> private_ips.txt"
  }
}
