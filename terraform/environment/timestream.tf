resource "aws_timestreamwrite_database" "timestream_database" {
  database_name = var.name
}

resource "aws_timestreamwrite_table" "timestream_database" {
  database_name = aws_timestreamwrite_database.timestream_database.database_name
  table_name    = var.name

  retention_properties {
    magnetic_store_retention_period_in_days = 30
    memory_store_retention_period_in_hours  = 8
  }
}
