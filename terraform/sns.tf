resource "aws_sns_topic" "security_alerts" {

  name = "FinancialCloudSecurityAlerts"

  tags = local.common_tags
}

resource "aws_sns_topic_subscription" "email_alerts" {

  topic_arn = aws_sns_topic.security_alerts.arn

  protocol = "email"

  endpoint = var.alert_email
}

