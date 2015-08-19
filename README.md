Zerocash Core
=====================================

This is a source code dump of code for a fork of the Bitcoin codebase made to use Zerocash.

At the moment, it is incomplete, does not build without manual changes to generated config files,  and should not be trusted for doing anything. Even if you do get it to build, there is no wallet.  It is prototype code intended for getting numbers in a paper, it was never finished, didn't work well for even those purposes, and was never intended to see the light of day, much less be used without massive cleanup that we have not yet done.  THE MODIFICATIONS TO BITCOIN MADE HERE SHOULD BE ASSUMED TO BE TOTALLY INSECURE.

There are others working on using this as a starting point and we are working with them. There is a large amount of work left.  However, we committed to open sourcing this version , so here.


License
-------

Zerocash Core is released under the terms of the MIT license. See [COPYING](COPYING) for more
information or see http://opensource.org/licenses/MIT.


## Build instructions

These instructions have been tested on a **Ubuntu 15.04 x86_64 desktop**
system. Other Linux distributions or versions may or may not work.

First, clone this repository with the `--recursive` option to pull
dependencies:

    $ git clone --recursive

Alternatively, if you already have cloned this repository non recursively, just
do a:

    $ git submodule update --init --recursive

Enter the directory and install package dependencies to build the software.
There is a script to do that for your convenience:

    $ cd zerocash/
    $ build/install-build-deps.sh

Then, generate the configure script, get and build dependencies by running:

    $ ./autogen.sh

If everything goes well, you should be able to compile zerocash by simply
typing

    $ make

Before running the server, libsnark must be added to the library path:

    $ sudo ln -sf $HOME/zerocash/libzerocash/depinst/lib/libsnark.so /usr/local/lib
    $ sudo ldconfig

## Running in the regtest mode

To test the code, create the directory which is going to hold the
configuration, blocks and wallet storage:

    $ mkdir -p $HOME/.bitcoin

Inside this directory, create a file named bitcoin.conf with the following
values:

    rpcuser=bitcoinrpc
    rpcpassword=<select a random secret>
    rpcport=8332

When this is done, you are ready to start the server:

    src/bitcoind -server -regtest -printtoconsole -debug

Now the server is ready to accept commands, use the included script as an
example:

    ./test2.sh