output "project_name" {
  value = var.project_name
}

output "aws_region" {
  value = var.aws_region
}

output "lambda_role_arn" {

  value = aws_iam_role.lambda_role.arn

}

output "dynamodb_table_name" {

  value = aws_dynamodb_table.security_findings.name

}

output "dynamodb_table_arn" {

  value = aws_dynamodb_table.security_findings.arn

}

output "sns_topic_name" {

  value = aws_sns_topic.security_alerts.name

}

output "sns_topic_arn" {

  value = aws_sns_topic.security_alerts.arn

}


output "lambda_name" {

  value = aws_lambda_function.security_scanner.function_name

}

output "lambda_arn" {

  value = aws_lambda_function.security_scanner.arn

}


output "eventbridge_rule" {

  value = aws_cloudwatch_event_rule.security_scan_schedule.name

}


output "cloudwatch_alarm_name" {
  value = aws_cloudwatch_metric_alarm.lambda_errors.alarm_name
}
