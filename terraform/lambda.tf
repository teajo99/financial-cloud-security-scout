data "archive_file" "lambda_zip" {
  type        = "zip"
  source_dir  = "${path.module}/../lambda"
  output_path = "${path.module}/lambda.zip"
}

resource "aws_lambda_function" "security_scanner" {

  function_name = "FinancialCloudSecurityScout"

  role = aws_iam_role.lambda_role.arn

  runtime = "python3.13"

  handler = "app.lambda_handler"

  filename         = data.archive_file.lambda_zip.output_path
  source_code_hash = data.archive_file.lambda_zip.output_base64sha256

  timeout = 300

  memory_size = 512

  environment {

    variables = {

      DYNAMODB_TABLE = aws_dynamodb_table.security_findings.name

      SNS_TOPIC_ARN = aws_sns_topic.security_alerts.arn

    }

  }

  tags = local.common_tags
}

resource "aws_cloudwatch_log_group" "lambda_logs" {

  name = "/aws/lambda/${aws_lambda_function.security_scanner.function_name}"

  retention_in_days = 30

  tags = local.common_tags
}
