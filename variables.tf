variable "environment_name" {
  description = "Environment name for your Pipeline (e.g. mycompany-poc)"
  type        = string
  default     = "mycompany-poc"
}

variable "apikeys" {
  default = {
    defaultKey = "610ad41b-6fde-4831-8580-f4d7dc769640"
  }

  type = map(string)
}
