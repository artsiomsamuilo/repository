provider "aws" {
    region = "eu-central-1"
}

terraform {
    backend "s3" {

        bucket = "infrastructurebck"
        key = "test/terraform.tfstate"
        region = "eu-central-1"
    }
}

data "aws_ami" "latest_ubuntu_linux" {

    owners = ["099720109477"]
    most_recent = true
    filter {
        name = "name"
        values = ["ubuntu/images/hvm-ssd/ubuntu-bionic-18.04-amd64-server-*"]
        
    }
}

resource "aws_instance" "jenkins_server" {
    ami = data.aws_ami.latest_ubuntu_linux.id
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.http_and_ssh_access.id]
    key_name = "sshkey"
}

resource "aws_security_group" "http_and_ssh_access" {
    name = "Access via http and ssh"

    dynamic "ingress" {
        for_each = ["80", "443", "22"]
        content {
            from_port = ingress.value
            to_port = ingress.value
            protocol = "tcp"
            cidr_blocks = ["0.0.0.0/0"]
        }
    }

    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
