FROM ubuntu:22.04

# Install required packages
RUN apt-get update && apt-get install -y \
    bluetooth \
    bluez \
    bluez-tools \
    node-typescript \
    nodejs \
    npm \
    python3 \
    && rm -rf /var/lib/apt/lists/*

# Copy the provisioning script
WORKDIR /app
COPY package*.json ./
COPY src/scripts/ble-provisioning.ts ./
COPY tsconfig.json ./

# Install Node.js dependencies
RUN npm install
RUN npm install -g ts-node

# Start Bluetooth service
CMD ["bash", "-c", "service bluetooth start && ts-node ble-provisioning.ts"]