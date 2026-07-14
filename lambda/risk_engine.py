RISK_SCORES = {

    "Public Write":100,

    "Public Read":90,

    "SSH Open":90,

    "RDP Open":90,

    "Database Port Open":85,

    "Database Publicly Accessible":85,

    "RDS Not Encrypted":75

}


def evaluate(issue):

    score = RISK_SCORES.get(issue, 50)

    if score >= 90:
        severity = "Critical"

    elif score >= 70:
        severity = "High"

    elif score >= 40:
        severity = "Medium"

    else:
        severity = "Low"

    return severity, score
