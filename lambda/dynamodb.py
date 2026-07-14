import boto3
import os

table = boto3.resource(
    "dynamodb"
).Table(
    os.environ["DYNAMODB_TABLE"]
)


def finding_exists(resource_id):

    response = table.query(

        KeyConditionExpression=
        boto3.dynamodb.conditions.Key(
            "ResourceId"
        ).eq(resource_id),

        Limit=1

    )

    return len(response["Items"]) > 0


def save_finding(finding):

    table.put_item(Item=finding)
