output "instance_ips" {
  value = ["${aws_instance.jenkins_server.public_ip}"]
}
