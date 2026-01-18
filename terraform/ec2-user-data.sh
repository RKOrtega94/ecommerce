#!/bin/bash
# EC2 user-data to bootstrap ECS agent on AL2
set -euxo pipefail

# Ensure ECS agent is running and pointing to our cluster
cat > /etc/ecs/ecs.config <<EOF
ECS_CLUSTER=${ECS_CLUSTER_NAME}
ECS_AVAILABLE_LOGGING_DRIVERS=["awslogs"]
EOF

systemctl enable --now ecs || true

# Optional: CloudWatch Logs agent for parity (may be no-op on LocalStack)
yum update -y
yum install -y awslogs
systemctl enable --now awslogsd || true

