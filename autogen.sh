#!/bin/sh
set -e
srcdir="$(readlink -e $(dirname $0))"
cd "$srcdir"
autoreconf --install --force

echo "Building dependencies..."

if [ $# -ge 1 ]; then
  if [ $1 = "debug" ]; then
    echo "Setting debug flags"
    DEBUG=debug
    CONFDBG="--enable-debug=yes"
  fi
fi

cd libzerocash/
./get-libsnark $DEBUG
make $DEBUG
cd ..

LD_LIBRARY_PATH=$srcdir/libzerocash/depinst/lib \
INCLUDES="-I$srcdir/libzerocash \
  -I$srcdir/libzerocash/depinst/include \
  -I$srcdir/libzerocash/depinst/include/libsnark" \
CXX="g++ -std=c++11 -DUSE_ASM -DMONTGOMERY_OUTPUT -DCURVE_BN128 \
  -DBN_SUPPORT_SNARK" \
LIBS="-L$srcdir/libzerocash \
  -L$srcdir/libzerocash/depinst/lib \
  -lzerocash -lcryptopp -lgmp -lsnark" \
./configure --with-incompatible-bdb --with-cli=no $CONFDBG
