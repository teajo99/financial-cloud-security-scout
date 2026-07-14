import boto3

from models import create_finding
from risk_engine import evaluate

rds = boto3.client("rds")


def scan():

    findings = []

    response = rds.describe_db_instances()

    for db in response["DBInstances"]:

        identifier = db["DBInstanceIdentifier"]

        if not db["StorageEncrypted"]:

            severity, score = evaluate(
                "RDS Not Encrypted"
            )

            findings.append(

                create_finding(

                    identifier,

                    "RDS",

                    "RDS Not Encrypted",

                    severity,

                    score,

                    "Enable encryption for the database."

                )

            )

        if db.get("PubliclyAccessible"):

            severity, score = evaluate(
                "Database Port Open"
            )

            findings.append(

                create_finding(

                    identifier,

                    "RDS",

                    "Database Publicly Accessible",

                    severity,

                    score,

                    "Disable public access to the database."

                )

            )

    return findings
