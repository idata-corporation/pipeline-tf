resource "aws_dynamodb_table" "dataset" {
  name          = "${var.environment_name}-dataset"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "name"
  table_class   = "STANDARD"

  attribute {
      name = "name"
      type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "trigger" {
  name          = "${var.environment_name}-trigger"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "name"
  table_class   = "STANDARD"

  attribute {
      name = "name"
      type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "archived-data" {
  name          = "${var.environment_name}-archived-data"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "pipeline_token"
  table_class   = "STANDARD"

  attribute {
      name = "pipeline_token"
      type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "archived-metadata" {
  name          = "${var.environment_name}-archived-metadata"
  billing_mode  = "PAY_PER_REQUEST"
  hash_key      = "pipeline_token"
  table_class   = "STANDARD"

  attribute {
      name = "pipeline_token"
      type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}