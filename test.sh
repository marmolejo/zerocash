#!/bin/bash

addr=$(./src/bitcoind -datadir=$HOME/tmp/z getnewaddress)

for foo in 1 2 3 4 5
do
inputx=$(./src/bitcoind -datadir=$HOME/tmp/z sendtoaddress $addr 25)
rawmint=$(./src/bitcoind -datadir=$HOME/tmp/z  zerocoinmint 42 2 $inputx)
signedtx=$(./src/bitcoind -datadir=$HOME/tmp/z signrawtransaction $rawmint)
tx=$(echo $signedtx | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["hex"]')
./src/bitcoind -datadir=$HOME/tmp/z sendrawtransaction $tx

done
