# Financial Cloud Security Scout

![AWS](https://img.shields.io/badge/AWS-Cloud-orange)
![Terraform](https://img.shields.io/badge/Terraform-Infrastructure%20as%20Code-purple)
![Python](https://img.shields.io/badge/Python-3.x-blue)
![Security](https://img.shields.io/badge/Focus-Cloud%20Security-red)

## Automated Cloud Security Posture Monitoring for Financial Workloads

---

# Executive Summary

Modern financial organisations are increasingly moving critical workloads to the cloud. While AWS provides secure infrastructure services, cloud security incidents frequently occur due to configuration mistakes rather than weaknesses in the cloud platform itself.

Examples of common cloud security failures include:

- Publicly accessible storage containing sensitive information.
- Security groups exposing administrative ports to the internet.
- Databases running without encryption.
- Poor visibility into continuously changing cloud environments.

**Financial Cloud Security Scout** is an automated Cloud Security Posture Management (CSPM) solution designed to continuously monitor AWS environments, identify security risks, evaluate their severity, store findings, and notify security teams.

The platform uses AWS serverless services and Infrastructure as Code to provide continuous security monitoring with minimal operational overhead.

---

# Business Problem

Financial organisations manage highly sensitive workloads including:

- Customer information.
- Payment systems.
- Transaction platforms.
- Internal business applications.
- Regulatory data.

A single cloud misconfiguration can expose critical systems and create:

- Data breach risk.
- Regulatory compliance failures.
- Financial losses.
- Operational disruption.
- Reputational damage.

Traditional security reviews are often:

- Manual.
- Periodic.
- Time-consuming.
- Unable to detect changes immediately.

Cloud environments are dynamic. New resources can be created within minutes, meaning security teams need continuous visibility rather than occasional assessments.

---

# Why This Project Was Created

I created Financial Cloud Security Scout to demonstrate how cloud security monitoring can be automated using modern cloud engineering practices.

The objective was to build a realistic security solution that combines:

- Infrastructure as Code.
- Serverless computing.
- Automated security scanning.
- Risk-based prioritisation.
- Security alerting.

The project demonstrates how organisations can move from reactive security reviews toward proactive continuous monitoring.

---

# Solution Overview

Financial Cloud Security Scout automatically scans AWS environments and identifies high-risk security configurations.

The solution:

1. Runs automated security scans using AWS Lambda.
2. Discovers AWS resources.
3. Evaluates resources against security best practices.
4. Assigns risk severity.
5. Stores findings for tracking and analysis.
6. Sends notifications when critical issues are detected.

The entire platform is deployed using Terraform, allowing consistent and repeatable infrastructure deployment.

---

# Business Value

This solution helps organisations:

- Improve cloud security visibility.
- Detect misconfigurations faster.
- Reduce manual security reviews.
- Prioritise the most dangerous risks.
- Improve incident response times.
- Support security compliance objectives.
- Create repeatable cloud security processes.

---

# Architecture

![Architecture Diagram](docs/architecture.png)

The solution follows a serverless security monitoring architecture:

```
                    EventBridge
                         |
                         |
                 Scheduled Scan Trigger
                         |
                         v
                  AWS Lambda Scanner
                         |
        ------------------------------------
        |                |                 |
        v                v                 v
       S3          Security Groups        RDS
     Scanner          Scanner           Scanner
        |                |                 |
        ------------------------------------
                         |
                         v
                  Risk Evaluation Engine
                         |
                         v
                    DynamoDB
                 Security Findings
                         |
                         v
                       SNS
                         |
                         v
                  Security Notifications
```

---

# Technology Stack

| Technology | Purpose |
|------------|---------|
| Terraform | Infrastructure as Code |
| AWS Lambda | Serverless security scanning engine |
| Python | Security automation logic |
| boto3 | AWS SDK for resource discovery |
| Amazon EventBridge | Automated scheduled scans |
| DynamoDB | Security findings database |
| Amazon SNS | Security alert notifications |
| CloudWatch | Logging and monitoring |
| IAM | Least privilege access control |

---

# Why These Technologies Were Selected

## Terraform

Terraform was selected because it allows cloud infrastructure to be:

- Version controlled.
- Repeatable.
- Auditable.
- Easily deployed across environments.

Instead of manually creating AWS resources, the entire security platform can be deployed through code.

---

## AWS Lambda

Lambda was selected because:

- No servers need to be maintained.
- It automatically scales.
- It is cost efficient for scheduled security scans.
- It integrates naturally with AWS services.

The scanner only runs when required, reducing operational overhead.

---

## Amazon EventBridge

EventBridge provides automated scheduling.

It allows security scans to run continuously without manual intervention.

Example:

```
Every 15 minutes
        |
        v
Lambda Security Scan
```

---

## DynamoDB

DynamoDB was selected because:

- It provides fast storage for security findings.
- It requires minimal administration.
- It scales automatically.
- It is suitable for storing security events over time.

---

## Amazon SNS

SNS was selected because security findings need immediate visibility.

SNS provides:

- Email notifications.
- Integration with other alerting systems.
- Simple event-driven communication.

---

## CloudWatch

CloudWatch provides:

- Lambda execution logs.
- Operational monitoring.
- Error tracking.
- Troubleshooting capability.

---

# Security Checks Implemented

## Amazon S3 Security

The scanner detects:

- Public bucket access.
- Public bucket policies.

Risk:

Public storage exposure can lead to accidental data disclosure.

---

## EC2 Security Group Security

The scanner detects:

- SSH exposed to the internet.
- RDP exposed to the internet.
- Database ports exposed publicly.

Monitored ports include:

| Port | Service |
|-|-|
| 22 | SSH |
| 3389 | RDP |
| 3306 | MySQL |
| 5432 | PostgreSQL |
| 1433 | SQL Server |
| 1521 | Oracle |

Risk:

Exposed administrative services increase the possibility of unauthorised access.

---

## Amazon RDS Security

The scanner detects:

- Databases without encryption enabled.
- Publicly accessible databases.

Risk:

Unprotected databases can expose sensitive business information.
---

# Risk Evaluation

Each finding is assigned a risk score.
Example:

| Issue | Risk Score | Severity |
|-|-|-|
| SSH Open To Internet | 90 | Critical |
| Public Database Access | 85 | High |
| RDS Encryption Disabled | 75 | High |
This allows security teams to focus on the highest priority issues first.

---

# Project Structure

```
financial-cloud-security-scout/
├── terraform/
│
│   ├── iam.tf
│   ├── lambda.tf
│   ├── dynamodb.tf
│   ├── sns.tf
│   ├── eventbridge.tf
│   ├── cloudwatch.tf
│
├── lambda/
│
│   ├── app.py
│   ├── risk_engine.py
│   ├── dynamodb.py
│   ├── notifier.py
│   ├── models.py
│
│   └── scanners/
│       ├── s3_scanner.py
│       ├── sg_scanner.py
│       └── rds_scanner.py
│
└── README.md
```

---

# Deployment

## Requirements

Before deployment install:

- AWS CLI
- Terraform
- Python 3.x

Configure AWS credentials:

```
aws configure
```

---

# Deploy Infrastructure

Navigate to Terraform:

```
cd terraform
```

Initialize Terraform:

```
terraform init
```

Validate configuration:

```
terraform validate
```

Review changes:

```
terraform plan
```

Deploy:

```
terraform apply
```

---

# How The System Works

Example workflow:

```
1. EventBridge starts scheduled scan

2. Lambda starts security assessment

3. Scanner checks AWS resources

4. Risk engine calculates severity

5. Findings stored in DynamoDB

6. Critical findings sent through SNS

7. Security team receives alert
```

---

# Example Security Finding

Example DynamoDB record:

```
Resource:
finance-production-bucket

Type:
S3

Issue:
Public Read Access

Severity:
Critical

Risk Score:
90

Recommendation:
Remove public access and enable S3 Block Public Access.
```

---

# Monitoring

The solution provides monitoring through:

- CloudWatch Logs.
- Lambda metrics.
- CloudWatch alarms.
- SNS notifications.

---

# Future Improvements

Potential future enhancements:

## Additional AWS Security Checks

- IAM privilege escalation detection.
- CloudTrail monitoring.
- AWS Config integration.
- GuardDuty findings integration.
- EBS encryption checks.
- Secrets exposure detection.

---

## Enterprise Features

Future versions could include:

- Multi-account AWS scanning.
- Compliance reporting.
- CIS Benchmark mapping.
- PCI DSS security checks.
- Automated remediation.
- Security dashboard.

---

# Lessons Learned

This project provided practical experience with:

- Designing cloud security automation.
- Building serverless applications.
- Implementing Infrastructure as Code.
- Applying least privilege IAM principles.
- Working with AWS APIs.
- Creating scalable security monitoring workflows.

---

# Conclusion

Financial Cloud Security Scout demonstrates how cloud security monitoring can be automated using AWS native services and Infrastructure as Code.

The project combines security engineering, cloud architecture, and automation to provide continuous visibility into AWS security risks.

By identifying vulnerabilities early and prioritising high-impact issues, organisations can reduce security exposure and improve their overall cloud security posture.

---

# Author

Your Name

GitHub: https://github.com/teajo99

LinkedIn: linkedin.com/in/temi-a-b406b618b

---


# License

This project is licensed under the MIT License.

| Public S3 Access | 90 | Critical |


