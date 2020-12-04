#!/bin/sh -e

# Set up EPEL
dnf install -y epel-release

# Set up sudo
dnf install -y sudo
echo "%wheel ALL=(ALL) NOPASSWD: ALL" > /etc/sudoers.d/allow-wheel-nopasswd

# Set up firewalld
dnf install -y firewalld
systemctl enable --now firewalld
firewall-cmd --zone=public --permanent --add-service=ssh

# Install dependencies
dnf install -y curl unzip tar
