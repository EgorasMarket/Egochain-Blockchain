#!/bin/bash

KEY="dev0"
CHAINID="dhives_5438-1"
MONIKER="groundzero"
DATA_DIR=$(mktemp -d -t evmos-datadir.dhives)

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

echo "create and add new keys"
$BINARY_PATH keys add $KEY --home $DATA_DIR --no-backup --chain-id $CHAINID --algo "eth_secp256k1" --keyring-backend test
echo "init Evmos with moniker=$MONIKER and chain-id=$CHAINID"
$BINARY_PATH init $MONIKER --chain-id $CHAINID --home $DATA_DIR
echo "prepare genesis: Allocate genesis accounts (10 million DHIVES)"
$BINARY_PATH add-genesis-account \
"$($BINARY_PATH keys show $KEY -a --home $DATA_DIR --keyring-backend test)" 10000000000000000000000000dhives \
--home $DATA_DIR --keyring-backend test
echo "prepare genesis: Sign genesis transaction (5 million DHIVES for validators)"
$BINARY_PATH gentx $KEY 5000000000000000000000000dhives --keyring-backend test --home $DATA_DIR --keyring-backend test --chain-id $CHAINID
echo "prepare genesis: Collect genesis tx"
$BINARY_PATH collect-gentxs --home $DATA_DIR
echo "prepare genesis: Run validate-genesis to ensure everything worked and that the genesis file is setup correctly"
$BINARY_PATH validate-genesis --home $DATA_DIR

echo "starting dhives node $i in background ..."
$BINARY_PATH start --pruning=nothing --rpc.unsafe \
--keyring-backend test --home $DATA_DIR \
--minimum-gas-prices 0.1dhives \
>$DATA_DIR/node.log 2>&1 & disown

echo "started dhives node"
tail -f /dev/null
