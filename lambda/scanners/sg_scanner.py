import boto3

from models import create_finding
from risk_engine import evaluate

ec2 = boto3.client("ec2")

HIGH_RISK_PORTS = {
    22: "SSH Open",
    3389: "RDP Open",
    3306: "Database Port Open",
    5432: "Database Port Open",
    1433: "Database Port Open",
    1521: "Database Port Open"
}


def scan():

    findings = []

    response = ec2.describe_security_groups()

    for sg in response["SecurityGroups"]:

        group_id = sg["GroupId"]

        for permission in sg.get("IpPermissions", []):

            from_port = permission.get("FromPort")

            if from_port is None:
                continue

            issue = HIGH_RISK_PORTS.get(from_port)

            if not issue:
                continue

            public = False

            for ip in permission.get("IpRanges", []):

                if ip["CidrIp"] == "0.0.0.0/0":
                    public = True

            for ip in permission.get("Ipv6Ranges", []):

                if ip["CidrIpv6"] == "::/0":
                    public = True

            if public:

                severity, score = evaluate(issue)

                findings.append(

                    create_finding(

                        group_id,

                        "SecurityGroup",

                        issue,

                        severity,

                        score,

                        f"Restrict access to port {from_port}."

                    )

                )

    return findings
