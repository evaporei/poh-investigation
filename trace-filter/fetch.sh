#!/usr/bin/env bash

# Usage: ./trace-filter/fetch.sh https://eth-mainnet.alchemyapi.io/v2/YOUR_KEY

set -e

# eg: https://eth-mainnet.alchemyapi.io/v2/YOUR_KEY
MAINNET_URL=$1

# Blocks:
# - 0xB81384 = 12063620
# - 0xC814F8 = 13112568 

# FROM_TO_BLOCK="0xB81384"
FROM_TO_BLOCK="0xC814F8"

# Contracts:
# - 0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb = ProofOfHumanity
# - 0x988b3A538b618C7A603e1c11Ab82Cd16dbE28069 = KlerosLiquid

curl --data '{"method":"trace_filter","params":[{"fromBlock":"'"$FROM_TO_BLOCK"'","toBlock":"'"$FROM_TO_BLOCK"'","toAddress":["0xc5e9ddebb09cd64dfacab4011a0d5cedaf7c9bdb", "0x988b3a538b618c7a603e1c11ab82cd16dbe28069"]}],"id":1,"jsonrpc":"2.0"}' -H "Content-Type: application/json" -X POST "$MAINNET_URL" > "trace-filter/toAddress$FROM_TO_BLOCK.json"
