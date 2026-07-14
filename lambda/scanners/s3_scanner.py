import boto3

from models import create_finding

from risk_engine import evaluate

s3 = boto3.client("s3")


def scan():

    findings = []

    buckets = s3.list_buckets()["Buckets"]

    for bucket in buckets:

        name = bucket["Name"]

        try:

            policy = s3.get_bucket_policy_status(
                Bucket=name
            )

            if policy["PolicyStatus"]["IsPublic"]:

                severity, score = evaluate(
                    "Public Read"
                )

                findings.append(

                    create_finding(

                        name,

                        "S3",

                        "Public Read",

                        severity,

                        score,

                        "Block public access immediately."

                    )

                )

        except Exception:

            pass

    return findings
