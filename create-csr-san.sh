#!/bin/bash

# Usage
if [ "$#" -lt 1 ]; then
    echo "Usage" $0 "<mydomain.com>"
    exit
fi

cat> openssl.cnf<<'EOF'
[req]
distinguished_name = req_distinguished_name
req_extensions = v3_req

[req_distinguished_name]
countryName = Country Name (2 letter code)
countryName_default = US
stateOrProvinceName = State or Province Name (full name)
stateOrProvinceName_default = WA
localityName = Locality Name (eg, city)
localityName_default = Seattle
organizationalUnitName  = Organizational Unit Name (eg, section)
organizationalUnitName_default  = Domain Control Validated
commonName = www.mycompany.com
commonName_max  = 64

[ v3_req ]
basicConstraints = CA:FALSE
keyUsage = nonRepudiation, digitalSignature, keyEncipherment
subjectAltName = @alt_names

[alt_names]
DNS.1 = secure.mycompany.com
DNS.2 = mycompany.com
DNS.3 = www.mycompany.com
EOF

openssl genrsa -out $1.key 2048

openssl req -new -out $1.csr \
  -key $1.key -sha256 \
  -subj '/C=US/ST=Washington/L=Seattle/O=Company/CN=mycompany.com' \
  -config openssl.cnf
cat $1.csr
