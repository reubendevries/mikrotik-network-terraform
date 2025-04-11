output "log_bucket" {
  description = "Log bucket details"
  value = {
    name = aws_s3_bucket.mikrotik_logs.id
    arn  = aws_s3_bucket.mikrotik_logs.arn
  }
}

output "cloudwatch_log_groups" {
  description = "CloudWatch log group names"
  value = {
    for k, v in aws_cloudwatch_log_group.router_logs : k => v.name
  }
}

output "sns_topic" {
  description = "SNS topic for alerts"
  value = aws_sns_topic.router_alerts.arn
}
