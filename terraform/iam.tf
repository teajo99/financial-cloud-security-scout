resource "aws_iam_role" "lambda_role" {

  name = "${var.project_name}-lambda-role"

  assume_role_policy = jsonencode({

    Version = "2012-10-17"

    Statement = [
      {
        Effect = "Allow"

        Principal = {
          Service = "lambda.amazonaws.com"
        }

        Action = "sts:AssumeRole"
      }
    ]
  })

  tags = local.common_tags
}


resource "aws_iam_policy" "cloudwatch_logs" {

  name = "${var.project_name}-cloudwatch"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "logs:CreateLogGroup",
          "logs:CreateLogStream",
          "logs:PutLogEvents"
        ]

        Resource = "*"
      }

    ]
  })
}


resource "aws_iam_policy" "s3_scan" {

  name = "${var.project_name}-s3-scan"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "s3:ListAllMyBuckets",
          "s3:GetBucketAcl",
          "s3:GetBucketPolicyStatus",
          "s3:GetBucketPublicAccessBlock"
        ]

        Resource = "*"
      }

    ]
  })
}

resource "aws_iam_policy" "ec2_scan" {

  name = "${var.project_name}-ec2-scan"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "ec2:DescribeSecurityGroups",
          "ec2:DescribeVpcs",
          "ec2:DescribeNetworkInterfaces"
        ]

        Resource = "*"
      }

    ]
  })
}


resource "aws_iam_policy" "rds_scan" {

  name = "${var.project_name}-rds-scan"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {
        Effect = "Allow"

        Action = [
          "rds:DescribeDBInstances"
        ]

        Resource = "*"
      }

    ]
  })
}

resource "aws_iam_policy" "dynamodb_write" {

  name = "${var.project_name}-dynamodb-write"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "dynamodb:PutItem",
          "dynamodb:UpdateItem",
          "dynamodb:GetItem",
          "dynamodb:Query"

        ]

        Resource = aws_dynamodb_table.security_findings.arn

      }

    ]

  })
}


resource "aws_iam_policy" "sns_publish" {

  name = "${var.project_name}-sns-publish"

  policy = jsonencode({

    Version = "2012-10-17"

    Statement = [

      {

        Effect = "Allow"

        Action = [

          "sns:Publish"

        ]

        Resource = aws_sns_topic.security_alerts.arn

      }

    ]

  })
}



resource "aws_iam_role_policy_attachment" "logs" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.cloudwatch_logs.arn

}

resource "aws_iam_role_policy_attachment" "s3" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.s3_scan.arn

}

resource "aws_iam_role_policy_attachment" "ec2" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.ec2_scan.arn

}

resource "aws_iam_role_policy_attachment" "rds" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.rds_scan.arn

}

resource "aws_iam_role_policy_attachment" "dynamodb" {

  role       = aws_iam_role.lambda_role.name
  policy_arn = aws_iam_policy.dynamodb_write.arn

}

resource "aws_iam_role_policy_attachment" "sns" {

  role = aws_iam_role.lambda_role.name

  policy_arn = aws_iam_policy.sns_publish.arn

}

