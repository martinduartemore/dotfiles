#!/usr/bin/env bash
set -euo pipefail

# --- Configuration (override via environment variables) ---
SOURCE_PROFILE="${AWS_MFA_SOURCE_PROFILE:?Set AWS_MFA_SOURCE_PROFILE to your base profile name}"
MFA_PROFILE="${AWS_MFA_PROFILE:-${SOURCE_PROFILE}-mfa}"
MFA_SERIAL="${AWS_MFA_SERIAL:?Set AWS_MFA_SERIAL to your MFA device ARN}"
DURATION="${AWS_MFA_DURATION:-43200}"

usage() {
    cat <<EOF
Usage: $(basename "$0") <mfa-token-code>

Generate temporary AWS credentials using MFA and configure them
into the [$MFA_PROFILE] profile.

Environment variables (optional):
  AWS_MFA_SOURCE_PROFILE  Base profile with long-lived keys (default: $SOURCE_PROFILE)
  AWS_MFA_PROFILE         Profile to store MFA credentials  (default: $MFA_PROFILE)
  AWS_MFA_SERIAL          MFA device ARN                    (default: $MFA_SERIAL)
  AWS_MFA_DURATION        Session duration in seconds        (default: $DURATION)
EOF
    exit 1
}

[[ $# -eq 1 ]] || usage

token_code="$1"

if ! [[ "$token_code" =~ ^[0-9]{6}$ ]]; then
    echo "Error: MFA token code must be exactly 6 digits." >&2
    exit 1
fi

echo "Requesting session token (profile=$SOURCE_PROFILE, duration=${DURATION}s)..."

read -r access_key secret_key session_token expiration < <(
    aws sts get-session-token \
        --profile "$SOURCE_PROFILE" \
        --duration-seconds "$DURATION" \
        --serial-number "$MFA_SERIAL" \
        --token-code "$token_code" \
        --query 'Credentials.[AccessKeyId,SecretAccessKey,SessionToken,Expiration]' \
        --output text
)

aws configure set aws_access_key_id "$access_key" --profile "$MFA_PROFILE"
aws configure set aws_secret_access_key "$secret_key" --profile "$MFA_PROFILE"
aws configure set aws_session_token "$session_token" --profile "$MFA_PROFILE"

echo "Credentials written to profile [$MFA_PROFILE]."
echo "Expires: $expiration"
echo ""
echo "Verifying..."
aws sts get-caller-identity --profile "$MFA_PROFILE"
