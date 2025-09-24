variable "region" {
  type        = string
  description = "AWS region"
  default     = "us-east-1"
}

variable "project" {
  type        = string
  description = "Project name"
  default     = "test-proj"
}

variable "vpc_cidr" {
  type    = string
  default = "10.1.0.0/16"
}

variable "public_subnet_cidr" {
  type        = string
  default     = "10.1.1.0/24"
  description = "CIDR for the public subnet"
}

variable "instance_type" {
  type    = string
  default = "t2.micro"
}
