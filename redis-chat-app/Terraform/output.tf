output "app_url" {
    description = "The URL to access the chat application"
    value       = "http://${aws_instance.chat_app.public_ip}:5000"
}

output "instance_public_ip" {
    description = "The public IP address of the EC2 instance"
    value       = aws_instance.chat_app.public_ip
}

output "instance_id" {
    description = "The ID of the EC2 instance"
    value       = aws_instance.chat_app.id
}

output "security_group_id" {
    description = "The ID of the security group"
    value       = aws_security_group.app_sg.id
}