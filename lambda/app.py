import json
import logging

from scanners.s3_scanner import scan as s3_scan
from scanners.sg_scanner import scan as sg_scan
from scanners.rds_scanner import scan as rds_scan

from dynamodb import save_finding, finding_exists
from notifier import notify

# Configure logging
logger = logging.getLogger()
logger.setLevel(logging.INFO)


def lambda_handler(event, context):

    logger.info("========================================")
    logger.info("Starting Financial Cloud Security Scout")
    logger.info("========================================")

    findings = []

    # ----------------------------
    # Scan S3 Buckets
    # ----------------------------
    try:
        logger.info("Running S3 Scanner...")
        s3_findings = s3_scan()
        findings.extend(s3_findings)
        logger.info(f"S3 Scanner completed. Findings: {len(s3_findings)}")

    except Exception:
        logger.exception("S3 Scanner failed.")

    # ----------------------------
    # Scan Security Groups
    # ----------------------------
    try:
        logger.info("Running Security Group Scanner...")
        sg_findings = sg_scan()
        findings.extend(sg_findings)
        logger.info(f"Security Group Scanner completed. Findings: {len(sg_findings)}")

    except Exception:
        logger.exception("Security Group Scanner failed.")

    # ----------------------------
    # Scan RDS Instances
    # ----------------------------
    try:
        logger.info("Running RDS Scanner...")
        rds_findings = rds_scan()
        findings.extend(rds_findings)
        logger.info(f"RDS Scanner completed. Findings: {len(rds_findings)}")

    except Exception:
        logger.exception("RDS Scanner failed.")

    logger.info(f"Total Findings Discovered: {len(findings)}")

    new_findings = 0

    # Save findings and notify
    for finding in findings:

        try:
            if not finding_exists(finding["ResourceId"]):

                save_finding(finding)

                if finding["Severity"] in ["Critical", "High"]:
                    notify(finding)

                new_findings += 1

        except Exception:
            logger.exception(
                f"Failed processing finding for {finding['ResourceId']}"
            )

    logger.info(f"New Findings Stored: {new_findings}")

    logger.info("Financial Cloud Security Scout Finished Successfully")

    return {
        "statusCode": 200,
        "body": json.dumps(
            {
                "message": "Financial Cloud Security Scout completed successfully.",
                "total_findings": len(findings),
                "new_findings": new_findings,
            }
        ),
    }
