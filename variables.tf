
variable "aws_region" {
  description = "AWS region"
  type        = string
  default     = "us-east-1"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "ssh_cidr_blocks" {
  description = "CIDR blocks allowed for SSH"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}

variable "welcome_message" {
  description = "Welcome message displayed on the website"
  type        = string
  default     = "Hello from Temporal + Terraform Cloud!"
}
