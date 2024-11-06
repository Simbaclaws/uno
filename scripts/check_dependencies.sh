#!/bin/bash

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Check for libpcap
if command_exists apt-get; then
    if ! dpkg -s libpcap-dev >/dev/null 2>&1; then
        echo "libpcap-dev not found. Installing..."
        sudo apt-get update
        sudo apt-get install -y libpcap-dev
    else
        echo "libpcap-dev is already installed."
    fi
elif command_exists dnf; then
    if ! rpm -q libpcap-devel >/dev/null 2>&1; then
        echo "libpcap-devel not found. Installing..."
        sudo dnf install -y libpcap-devel
    else
        echo "libpcap-devel is already installed."
    fi
elif command_exists brew; then
    if ! brew list libpcap >/dev/null 2>&1; then
        echo "libpcap not found. Installing..."
        brew install libpcap
    else
        echo "libpcap is already installed."
    fi
else
    echo "Package manager not supported. Please install libpcap manually."
    exit 1
fi

echo "All dependencies are installed."

