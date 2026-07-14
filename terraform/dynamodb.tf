resource "aws_dynamodb_table" "security_findings" {

  name         = "FinancialCloudSecurityFindings"
  billing_mode = "PAY_PER_REQUEST"

  hash_key  = "ResourceId"
  range_key = "Timestamp"

  attribute {
    name = "ResourceId"
    type = "S"
  }

  attribute {
    name = "Timestamp"
    type = "S"
  }

  tags = local.common_tags
}
