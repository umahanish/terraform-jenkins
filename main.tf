variable "awsprops" {
    type = map
    default = {
    region = "eu-west-2"
    vpc = "vpc-0b8f9db95ea75373d"
    ami = "ami-0b25f6ba2f4419235"
    itype = "t2.micro"
    subnet = "subnet-08035b0f3608bb652"
    publicip = true
    keyname = "umakey"
    secgroupname = "Terraform-linux-sgrp1"
  }
  }


provider "aws" {
  region = lookup(var.awsprops, "region")
}

resource "aws_security_group" "terraformsgrp" {
  name = lookup(var.awsprops, "secgroupname")
  description = lookup(var.awsprops, "secgroupname")
  vpc_id = lookup(var.awsprops, "vpc")

  // To Allow SSH Transport
  ingress {
     from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 80 Transport
  ingress {
    from_port = 80
    protocol = "tcp"
    to_port = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  // To Allow Port 8080 Transport
  ingress {
    from_port = 8080
    protocol = "tcp"
    to_port = 8080
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port       = 0
    to_port         = 0
    protocol        = "-1"
    cidr_blocks     = ["0.0.0.0/0"]
  }

  lifecycle {
    create_before_destroy = true
  }
}


resource "aws_instance" "project-iac" {
  ami = lookup(var.awsprops, "ami")
  instance_type = lookup(var.awsprops, "itype")
  subnet_id = lookup(var.awsprops, "subnet") #FFXsubnet2
  associate_public_ip_address = lookup(var.awsprops, "publicip")
  key_name = lookup(var.awsprops, "keyname")


  vpc_security_group_ids = [
    aws_security_group.terraformsgrp.id
  ]
  root_block_device {
    delete_on_termination = true
    #iops = 150
    volume_size = 8
    volume_type = "gp2"
  }
  tags = {
    Name ="Tomcat-Server"
    Environment = "DEV"
    OS = "Amazon Linux 2"
    Managed = "IAC"
  }
  user_data = file("script.sh")
  depends_on = [ aws_security_group.terraformsgrp ]
}

output "ec2instance" {
  value = aws_instance.project-iac.public_ip
}
