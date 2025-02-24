#!/bin/bash
# Installing the awslogs agent
sudo yum update -y
sudo yum install -y awslogs

# Get the Instance ID
INSTANCE_ID=$(curl http://169.254.169.254/latest/meta-data/instance-id)

# Configuring the awslogs agent
cat > /etc/awslogs/awslogs.conf <<EOL
[general]
state_file = /var/lib/awslogs/agent-state

file = /var/log/httpd/access_log # Or the correct access log path for your setup
buffer_duration = 5
log_stream_name = ${INSTANCE_ID}-access
initial_position = start_of_file
datetime_format = %Y-%m-%d %H:%M:%S
log_group_name = wordpress-access-logs
EOL

# Start the awslogs agent
sudo systemctl start awslogs
sudo systemctl enable awslogs # Enabling on boot
