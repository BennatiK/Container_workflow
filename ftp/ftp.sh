#!/bin/bash

# Assign input arguments to variables
USERNAME="test"
PASSWORD="Test1234"


# Create a new SFTP-only group
groupadd sftp_users

# Create a new user and set the password
useradd -m -g sftp_users -s /bin/bash -d /mnt/ $USERNAME
echo "$USERNAME:$PASSWORD" | chpasswd

# Configure SSH server to enable SFTP-only access
echo -e "\nMatch User $USERNAME" >> /etc/ssh/sshd_config
echo "    ForceCommand internal-sftp" >> /etc/ssh/sshd_config
echo "    PasswordAuthentication yes" >> /etc/ssh/sshd_config
#echo "    ChrootDirectory /home/$USERNAME" >> /etc/ssh/sshd_config  # Commented out to allow full access to the machine
echo "    PermitTunnel no" >> /etc/ssh/sshd_config
echo "    AllowAgentForwarding no" >> /etc/ssh/sshd_config
echo "    AllowTcpForwarding no" >> /etc/ssh/sshd_config
echo "    X11Forwarding no" >> /etc/ssh/sshd_config

# Restart the SSH server to apply changes
systemctl restart sshd

echo "SFTP server setup complete for user: $USERNAME"
