from datetime import datetime


def create_finding(
    resource_id,
    resource_type,
    issue,
    severity,
    risk_score,
    recommendation,
):

    return {

        "ResourceId": resource_id,

        "Timestamp": datetime.utcnow().isoformat(),

        "ResourceType": resource_type,

        "Issue": issue,

        "Severity": severity,

        "RiskScore": risk_score,

        "Recommendation": recommendation,

        "Status": "Open"

    }
