#!/bin/bash

## Define the tmux session name
SESSION_NAME="ansible_migration"

# Define the directory where your ansible playbooks are located
ANSIBLE_DIRECTORY="/home/ec2-user/ansible/migrate-wordpress-for-staging"

# Define the playbooks and inventory file
PLAYBOOK="migrate-wordpress.yml"
UPDATE_HOSTS_PLAYBOOK="update-hosts.yml"
INVENTORY="hosts.ini"

# Check and kill the existing tmux session if it exists
tmux has-session -t $SESSION_NAME 2>/dev/null
if [ $? == 0 ]; then
    echo "Found existing tmux session: $SESSION_NAME. Killing it..."
    tmux kill-session -t $SESSION_NAME
fi

# Create a new tmux session but do not attach yet
echo "Creating new tmux session: $SESSION_NAME"
tmux new-session -d -s $SESSION_NAME

# First update the hosts.ini file in the tmux session
echo "Updating hosts.ini with the correct prod_server IP"
tmux send-keys -t $SESSION_NAME "cd $ANSIBLE_DIRECTORY" C-m
tmux send-keys -t $SESSION_NAME "ansible-playbook -i localhost $UPDATE_HOSTS_PLAYBOOK" C-m

# Wait for the inventory to be updated
sleep 10  # Adjust the sleep time if needed, depending on how long the update takes

# Then execute the main ansible playbook in the tmux session
echo "Executing Ansible playbook in tmux session: $SESSION_NAME"
tmux send-keys -t $SESSION_NAME "ansible-playbook -i $INVENTORY $PLAYBOOK" C-m

# Give a little time for the playbook command to be visually noticeable in tmux before attaching
sleep 2

# Automatically attach to the tmux session
echo "Attaching to tmux session: $SESSION_NAME"
tmux attach-session -t $SESSION_NAME

