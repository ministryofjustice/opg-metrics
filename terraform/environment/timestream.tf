resource "aws_timestreamwrite_database" "timestream_database" {
  database_name = var.name

  tags = {
    Name = "value"
  }
}

resource "aws_timestreamwrite_table" "timestream_database" {
  database_name = aws_timestreamwrite_database.timestream_database.database_name
  table_name    = var.name

  retention_properties {
    magnetic_store_retention_period_in_days = 30
    memory_store_retention_period_in_hours  = 8
  }

  tags = {
    Name = local.mandatory_moj_tags
  }
}
