#!/bin/sh

set -e
set -v

git clone http://git.haproxy.org/git/haproxy-1.7.git 
cd haproxy-1.7
make TARGET=cygwin USE_OPENSSL=1 USE_ZLIB=1 -j3
echo "Look at all linked libraries below and copy them together with binary:"
ldd haproxy.exe
