#!/bin/bash

# Usage
if [ "$#" -lt 1 ]; then
    echo "Usage" $0 "<mydomain.com>"
    exit
fi

openssl genrsa -out $1.key 2048
openssl req -new -sha256 -key $1.key -out $1.csr
cat $1.csr

