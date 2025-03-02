#!/bin/bash

# Configuration variables
KEY="validator2"  # Change this for each new validator
CHAINID="dhives_5438-1"
MONIKER="validator2"  # Change this for each new validator
DATA_DIR="$HOME/.dhives"  # Using a fixed data directory
PERSISTENT_PEERS="<first_node_id>@<first_node_ip>:26656"  # Replace with actual node ID and IP

# Check multiple possible locations for dhivesd binary
BINARY_PATH=""
for path in "/usr/bin/dhivesd" "$HOME/go/bin/dhivesd" "/usr/local/bin/dhivesd"; do
    if [ -x "$path" ]; then
        BINARY_PATH="$path"
        break
    fi
done

if [ -z "$BINARY_PATH" ]; then
    echo "Error: dhivesd binary not found in standard locations (/usr/bin, ~/go/bin, /usr/local/bin)"
    echo "Please build the binary using 'make build' and ensure it is installed in one of these locations"
    exit 1
fi

# Initialize the node
echo "Initializing node with moniker=$MONIKER and chain-id=$CHAINID"
$BINARY_PATH init $MONIKER --chain-id $CHAINID --home $DATA_DIR

# Create validator key
echo "Creating validator key..."
$BINARY_PATH keys add $KEY --home $DATA_DIR --keyring-backend test --algo "eth_secp256k1"

# Download genesis.json from the first node
echo "Please copy genesis.json from the first node to $DATA_DIR/config/genesis.json"
read -p "Press enter after you have copied the genesis.json file..."

# Validate genesis
echo "Validating genesis file..."
$BINARY_PATH validate-genesis --home $DATA_DIR

# Update config.toml with persistent peers
echo "Updating config with persistent peers..."
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PERSISTENT_PEERS\"/" $DATA_DIR/config/config.toml

# Start the node
echo "Starting dhives node..."
$BINARY_PATH start --home $DATA_DIR \
--minimum-gas-prices 0.1dhives \
--p2p.persistent_peers $PERSISTENT_PEERS

echo "Node started. Use 'dhivesd status' to check sync status"
