variable "region" {
    description = "The AWS region to deploy resources in"
    type        = string
    default     = "ap-south-1"
    }
variable "instance_type" {
    description = "The type of AWS EC2 instance to use"
    type        = string
    default     = "t3.micro"
    }
variable "ami_id" {
    description = "The AMI ID to use for the EC2 instance"      
    type        = string
    default     = "ami-02b8269d5e85954ef"                     
    }
variable "key_name" {
    description = "The name of the key pair to use for SSH access"  
    type        = string
    default     = "krishna-316"
    }   