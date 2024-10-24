#!/bin/bash
export XINFIN_RPC_URL="https://erpc.xinfin.network/"
export APOTHEM_RPC_URL="https://erpc.apothem.network/"
export SEPOLIA_RPC_URL="https://rpc.sepolia.org"

forge create \
    --rpc-url ${APOTHEM_RPC_URL} \
    --private-key ${PRIVATE_KEY} \
    src/workout/WorkoutManagement.sol:WorkoutManagement \
    --constructor-args "Workout" "1" \
    --legacy

