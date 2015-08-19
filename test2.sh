#!/bin/bash

bc="./src/bitcoind"

$bc setgenerate true 102

a1=$($bc getnewaddress)
itx1=$($bc sendtoaddress $a1 25)
rm1=$($bc zerocoinmint 42 2 $itx1)
ztx1=$(echo $rm1 | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["hex"]')
stx1=$($bc signrawtransaction $ztx1)
tx1=$(echo $stx1 | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["hex"]')
srw1=$($bc sendrawtransaction $tx1)

a2=$($bc getnewaddress)
itx2=$($bc sendtoaddress $a2 25)
rm2=$($bc zerocoinmint 42 2 $itx2)
ztx2=$(echo $rm2 | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["hex"]')
stx2=$($bc signrawtransaction $ztx2)
tx2=$(echo $stx2 | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["hex"]')
srw2=$($bc sendrawtransaction $tx2)

$bc setgenerate true 1

a3=$($bc getnewaddress)

cid1=$(echo $rm1 | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["cid"]')
cid2=$(echo $rm2 | python -c 'import sys,json;data=json.loads(sys.stdin.read()); print data["cid"]')

$bc zerocoinpour $a3 true $cid1 $cid2
