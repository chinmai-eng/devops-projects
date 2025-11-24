resource "aws_security_group" "app_sg" {
    name       = "app_sg"
    description = "Allow SSH and HTTP access"    
    ingress {
        from_port   = 22
        to_port     = 22
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"] 
    }
    ingress {
        from_port   = 5000
        to_port     = 5000
        protocol    = "tcp"
        cidr_blocks = ["0.0.0.0/0"]     
    }
    egress {
        from_port   = 0
        to_port     = 0
        protocol    = "-1"
        cidr_blocks = ["0.0.0.0/0"]
    }
}
resource "aws_instance" "chat_app" {
    ami           = var.ami_id
    instance_type = var.instance_type
    key_name      = var.key_name
    security_groups = [aws_security_group.app_sg.name]
    user_data = <<-EOF
                #!/bin/bash
                apt update -y
                apt install docker.io -y    
                systemctl start docker
                systemctl enable docker
                docker pull chinmaich316/redis-chat-app:latest
                docker run -d -p 5000:5000 chinmaich316/redis-chat-app:latest
                EOF
    tags = {
        Name = "Redis-chat-app"        
    }
}                               