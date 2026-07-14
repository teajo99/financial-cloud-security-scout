import boto3
import os

sns = boto3.client("sns")


def notify(finding):

    message = f"""

Financial Cloud Security Scout

Severity:
{finding['Severity']}

Resource:
{finding['ResourceId']}

Issue:
{finding['Issue']}

Risk Score:
{finding['RiskScore']}

Recommendation:
{finding['Recommendation']}

"""

    sns.publish(

        TopicArn=os.environ["SNS_TOPIC_ARN"],

        Subject="Financial Cloud Security Alert",

        Message=message

    )
