#!/bin/sh
set -e
srcdir="$(readlink -e $(dirname $0))"
cd "$srcdir"
autoreconf --install --force

echo "Building dependencies..."

cd libzerocash/
./get-libsnark
make
cd ..

LD_LIBRARY_PATH=$srcdir/libzerocash/depinst/lib \
INCLUDES="-I$srcdir/libzerocash \
  -I$srcdir/libzerocash/depinst/include \
  -I$srcdir/libzerocash/depinst/include/libsnark" \
CXXFLAGS="-std=c++11 -DUSE_ASM -DMONTGOMERY_OUTPUT -DCURVE_BN128 -DBN_SUPPORT_SNARK" \
LIBS="-L$srcdir/libzerocash \
  -L$srcdir/libzerocash/depinst/lib \
  -lzerocash -lcryptopp -lgmp -lsnark" \
./configure --with-incompatible-bdb --with-cli=no
