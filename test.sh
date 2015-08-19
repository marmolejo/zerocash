#!/bin/bash

addr=$(./src/bitcoind getnewaddress)

for foo in 1 2 3 4 5
do
inputx=$(./src/bitcoind sendtoaddress $addr 25)
rawmint=$(./src/bitcoind zerocoinmint 42 2 $inputx)
signedtx=$(./src/bitcoind signrawtransaction $rawmint)
tx=$(echo $signedtx | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["hex"]')
./src/bitcoind sendrawtransaction $tx

done
