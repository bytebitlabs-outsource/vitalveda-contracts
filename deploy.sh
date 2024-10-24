#!/bin/bash
source .env

forge script script/VitalVEDA.s.sol:DeployScript \
    --rpc-url ${APOTHEM_RPC_URL} \
    --broadcast \
    --optimize true \
    --optimizer-runs 200 \
    --private-key ${PRIVATE_KEY} \
    --legacy \
    -vvvv
