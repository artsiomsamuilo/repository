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
    vpc_security_group_ids = [module.aws_sg_default.aws_security_group]
    user_data = file("user_data.sh")
    key_name = "sshkey"
}

module "aws_sg_default" {
    source = "../modules/aws_security_group"
}
