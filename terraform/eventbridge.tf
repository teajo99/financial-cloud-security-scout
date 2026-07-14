resource "aws_cloudwatch_event_rule" "security_scan_schedule" {

  name = "financial-cloud-security-scan"

  description = "Runs the Financial Cloud Security Scout every 15 minutes"

  schedule_expression = "rate(15 minutes)"

  tags = local.common_tags
}

resource "aws_cloudwatch_event_target" "lambda_target" {

  rule = aws_cloudwatch_event_rule.security_scan_schedule.name

  arn = aws_lambda_function.security_scanner.arn
}

resource "aws_lambda_permission" "allow_eventbridge" {

  statement_id = "AllowExecutionFromEventBridge"

  action = "lambda:InvokeFunction"

  function_name = aws_lambda_function.security_scanner.function_name

  principal = "events.amazonaws.com"

  source_arn = aws_cloudwatch_event_rule.security_scan_schedule.arn
}


