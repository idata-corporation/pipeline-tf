resource "aws_dynamodb_table" "config" {
  name          = "${var.environment_name}-config"
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

resource "aws_dynamodb_table" "dataset" {
  name         = "${var.environment_name}-dataset"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"
  table_class  = "STANDARD"

  attribute {
    name = "name"
    type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "trigger" {
  name         = "${var.environment_name}-trigger"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "name"
  table_class  = "STANDARD"

  attribute {
    name = "name"
    type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "archived-data" {
  name         = "${var.environment_name}-archived-data"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pipeline_token"
  table_class  = "STANDARD"

  attribute {
    name = "pipeline_token"
    type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "archived-metadata" {
  name         = "${var.environment_name}-archived-metadata"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pipeline_token"
  table_class  = "STANDARD"

  attribute {
    name = "pipeline_token"
    type = "S"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "dataset-status-summary" {
  name         = "${var.environment_name}-dataset-status-summary"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pipeline_token"
  range_key    = "created_at"
  table_class  = "STANDARD"

  attribute {
    name = "pipeline_token"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "dataset-status" {
  name         = "${var.environment_name}-dataset-status"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "pipeline_token"
  range_key    = "created_at"
  table_class  = "STANDARD"

  attribute {
    name = "pipeline_token"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "trigger-status-summary" {
  name         = "${var.environment_name}-trigger-status-summary"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "trigger_token"
  range_key    = "created_at"
  table_class  = "STANDARD"

  attribute {
    name = "trigger_token"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  tags = {
    Name = var.environment_name
  }
}

resource "aws_dynamodb_table" "trigger-status" {
  name         = "${var.environment_name}-trigger-status"
  billing_mode = "PAY_PER_REQUEST"
  hash_key     = "trigger_token"
  range_key    = "created_at"
  table_class  = "STANDARD"

  attribute {
    name = "trigger_token"
    type = "S"
  }

  attribute {
    name = "created_at"
    type = "N"
  }

  tags = {
    Name = var.environment_name
  }
}
