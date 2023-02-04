# provider variable
variable "aws_region" {
  description = "Configuring AWS as provider"
  type        = string
  default     = "us-east-1"
}

# keys to the castle variable
variable "aws_access_key" {
  type      = string
  sensitive = true
}

variable "aws_secret_key" {
  type      = string
  sensitive = true
}

variable "vpc_name" {
  description = "Name of VPC"
  type        = string
  default     = "vpc-demo"
}

# vpc variable
variable "vpc_cidr" {
  description = "CIDR block for main"
  type        = string
  default     = "172.16.0.0/16"
}

# availability zones variable
variable "availability_zones" {
  description = "Availability zones for VPC"
  type        = list(string)
  default     = ["us-east-1a", "us-east-1b"]
}

variable "vpc_private_subnets" {
  description = "Private subnets for VPC"
  type        = list(string)
  default     = ["172.16.1.0/24", "172.16.2.0/24"]
}

variable "vpc_public_subnets" {
  description = "Public subnets for VPC"
  type        = list(string)
  default     = ["172.16.10.0/24", "172.16.12.0/24"]
}

variable "vpc_db_subnets" {
  description = "Database subnets for VPC"
  type        = list(string)
  default     = ["172.16.14.0/24", "172.16.16.0/24"]
}

variable "vpc_tags" {
  description = "Tags to apply to resources created by VPC module"
  type        = map(string)
  default = {
    Terraform   = "true"
    Environment = "dev"
    Application = "nginx-service"
  }
}

variable "task_name" {
  description = "Task Name for ECS"
  type        = string
  default     = "nginx-service"
}

variable "ingress_ip_service" {
  description = "Change with the NAB Public IPs"
  type        = list(string)
  default     = ["0.0.0.0/0"]
}