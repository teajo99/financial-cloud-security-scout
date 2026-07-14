resource "aws_cloudwatch_metric_alarm" "lambda_errors" {
  alarm_name          = "FinancialCloudSecurityScoutErrors"
  comparison_operator = "GreaterThanOrEqualToThreshold"
  evaluation_periods  = 1
  metric_name         = "Errors"
  namespace           = "AWS/Lambda"
  period              = 300
  statistic           = "Sum"
  threshold           = 1

  alarm_description = "Alarm when the Financial Cloud Security Scout Lambda reports errors."

  dimensions = {
    FunctionName = aws_lambda_function.security_scanner.function_name
  }

  alarm_actions = [
    aws_sns_topic.security_alerts.arn
  ]

  tags = local.common_tags
}
