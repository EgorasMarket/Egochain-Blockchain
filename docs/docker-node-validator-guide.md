# Docker Node and Validator Setup Guide

## 1. Introduction & Overview

This guide provides comprehensive instructions for setting up and running a dhives network node using Docker, and joining the network as a validator. The dhives network consists of two primary roles:

- **Node**: A full network participant that maintains a copy of the blockchain
- **Validator**: A node with additional responsibilities for block production and network consensus

## 2. Prerequisites

Before proceeding with the setup, ensure you have the following requirements:

- Docker installed and running
- docker-compose installed
- `dhivesd` binary available in one of these locations:
  - `/usr/bin/dhivesd`
  - `~/go/bin/dhivesd`
  - `/usr/local/bin/dhivesd`

If the `dhivesd` binary is not present, build and install it using:

```bash
make build
```

## 3. Starting a Docker Node

The `scripts/start-docker.sh` script automates the node setup process. Here's what it does:

### Script Functionality

1. Creates a temporary data directory using `mktemp`
2. Verifies the presence of `dhivesd` binary
3. Creates a new key (KEY="dev0")
4. Initializes the node with specified moniker and chain-id
5. Allocates genesis funds
6. Signs the genesis transaction
7. Collects genesis transactions
8. Validates the genesis file
9. Starts the node in background with log redirection

### Verification Steps

After running the script:

1. Check node status using:
   ```bash
   dhivesd status
   ```
2. Monitor logs for successful startup
3. Verify network connectivity

## 4. Joining as a Validator

The `scripts/join-network.sh` script facilitates joining the network as a validator.

### Key Differences from start-docker.sh

- Uses fixed data directory (`$HOME/.dhives`)
- Creates validator key (KEY="validator2")
- Requires manual genesis.json file copy
- Updates peer configuration

### Setup Process

1. Run the join-network.sh script
2. Copy genesis.json from the first node:
   ```bash
   cp <first-node-path>/config/genesis.json $HOME/.dhives/config/
   ```
3. Validate genesis file
4. Update peer configuration
5. Start the node with persistent peers

## 5. Docker & Network Configuration

### Dockerfile Overview

The Dockerfile implements a multi-stage build:
- Stage 1: Build environment setup
- Stage 2: Final container configuration
  - Binary copying
  - Dependency installation
  - Environment setup

### docker-compose.yml Structure

Key components:
- Service definitions
- Port mappings (26656, 26657, 1317, 9090)
- Volume bindings
- Network configuration

## 6. Troubleshooting and Best Practices

### Common Issues

1. Missing Binary
   - Solution: Verify installation path
   - Rebuild if necessary

2. Genesis File Errors
   - Verify file integrity
   - Check proper copying from source

3. Network Connectivity
   - Check firewall settings
   - Verify peer configurations

### Best Practices

- Regular log monitoring
- Backup configuration files
- Maintain proper system resources
- Regular status checks using `dhivesd status`

### Debugging Tips

1. Check logs:
   ```bash
   docker logs <container-name>
   ```
2. Verify network status
3. Monitor resource usage

## 7. Conclusion and Further Resources

This guide covers the essential aspects of setting up and running a dhives node using Docker and joining as a validator. For additional information:

- Official Documentation
- Community Forums
- GitHub Repository
- Technical Support Channels

Remember to regularly check for updates and maintain your node's security and performance.