resource "aws_secretsmanager_secret" "apikeys" {
  name = "${var.environment_name}-apikeys"
}

resource "aws_secretsmanager_secret_version" "apikeys" {
  secret_id     = aws_secretsmanager_secret.apikeys.id
  secret_string = jsonencode(var.apikeys)
}

variable "apikeys" {
  default = {
    defaultKey = "610ad41b-6fde-4831-8580-f4d7dc769640"
  }

  type = map(string)
}