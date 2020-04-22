resource "snowflake_schema" "schema" {
  for_each = var.schemas
  name     = each.key
  database = each.value.database
  comment  = each.value.comment
}
