#!/bin/bash
sudo apt-get update && sudo apt-get upgrade -y
# Install SSM Agent using yum package manager
sudo apt-get install -y amazon-ssm-agent

# Start and enable the SSM Agent service
sudo systemctl enable amazon-ssm-agent
sudo systemctl start amazon-ssm-agent
