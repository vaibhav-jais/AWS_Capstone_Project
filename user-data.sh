#!/bin/bash
# Installing the awslogs agent
sudo yum update -y
sudo yum install -y awslogs

# Configuring the awslogs agent
cat > /etc/awslogs/awslogs.conf <<EOL
[general]
state_file = /var/lib/awslogs/agent-state

[${aws_s3_bucket.wordpress_logs.bucket}-wordpress-access]
file = /var/log/httpd/access_log # Or the correct access log path for your setup
buffer_duration = 5
log_stream_name = {instance_id}-access
initial_position = start_of_file
datetime_format = %Y-%m-%d %H:%M:%S
log_group_name = wordpress-access-logs
EOL

# Start the awslogs agent
sudo systemctl start awslogs
sudo systemctl enable awslogs # Enabling on boot
