variable "aws_account_id" {
  description = "Your AWS account ID"
  type        = string
  default     = "116279234263"
}

variable "environment_name" {
  description = "Environment name for your Pipeline (e.g. mycompany-dev)"
  type        = string
  default     = "mycompany-dev"
}