#!/bin/bash

# Install Lima (if not installed)
if ! command -v lima &> /dev/null; then
    echo "Installing Lima..."
    brew install lima
fi

# Create Lima VM with USB passthrough
lima create --name bluetooth-vm ubuntu-lts

# Start the VM
lima start bluetooth-vm

# Install required packages in VM
lima shell bluetooth-vm <<EOF
sudo apt-get update
sudo apt-get install -y bluetooth bluez bluez-tools nodejs npm python3
sudo systemctl enable bluetooth
sudo systemctl start bluetooth

# Install Node.js dependencies
npm install node-ble typescript ts-node
EOF

echo "VM created! Now:"
echo "1. Find your device MAC: lima shell bluetooth-vm sudo bluetoothctl"
echo "2. Edit the provisioning script with your local IP"
echo "3. Run: lima shell bluetooth-vm ts-node ble-provisioning.ts"