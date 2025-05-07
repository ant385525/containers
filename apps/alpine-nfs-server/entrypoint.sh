#!/bin/sh

rpcbind
exportfs -r
rpc.nfsd
rpc.mountd -F
