# x509 shell command one liners

**CERT: Display all certificates - subject, expiry, signature algorithm, fingerprint, modulus md5 sum (recursive)**

```
for CERT in $(grep -lrs '\-BEGIN CERTIFICATE\-' .);do echo; echo "Cert:" $CERT; CERTV=$(openssl x509 -text -noout -in $CERT);echo -n "Subject: ";echo "$CERTV"|grep -i [S]ubject:|cut -d ':' -f 2;echo -n "Issuer Date: ";echo "$CERTV"|grep -i [B]efore|awk '{print $6}';echo "$CERTV"|grep -i [A]fter|sed 's/Not\ After\ :/Expire Date:/g'|awk '{gsub(/^ +| +$/,"")}1';echo "$CERTV"|grep -i [S]ignature\ [A]lgorithm|head -1|awk '{gsub(/^ +| +$/,"")}1';openssl x509 -noout -in $CERT -fingerprint|sed 's/SHA1\ Fingerprint=/Fingerprint: /g';echo -n "Cert hash: ";openssl x509 -noout -modulus -in $CERT|openssl md5|awk '{print $2}';done
```

*example output*
<pre>
Cert: ./amazon.com.crt
Subject:  C=US, ST=Washington, L=Seattle, O=Amazon.com, Inc., CN=www.amazon.com
Issuer Date: 2015
Expire Date: Oct  2 23:59:59 2015 GMT
Signature Algorithm: sha1WithRSAEncryption
Fingerprint: 66:6C:18:9B:DD:FF:23:B4:2F:B1:DE:42:FD:A1:86:30:36:D5:70:6D
Cert hash: 83987c7eaf3c818aa32baf1eb6df4fa4

Cert: ./google.com.crt
Subject:  C=US, ST=California, L=Mountain View, O=Google Inc, CN=*.google.com
Issuer Date: 2015
Expire Date: Jul 21 00:00:00 2015 GMT
Signature Algorithm: sha1WithRSAEncryption
Fingerprint: C0:90:DF:D3:B6:7D:FD:9A:96:EF:20:13:6F:CC:3E:CD:D1:60:A5:45
Cert hash: 4b6f1ba408a3438cea316cc7430fe98a
</pre>

**KEY: Display rsa key - modulus md5 sum (recursive)**

```
for KEY in $(grep -lrs '\-BEGIN RSA PRIVATE KEY\-' .); do echo;echo "Key:" $KEY;openssl rsa -noout -text -in $KEY|grep bit;echo -n "Key hash: "; openssl rsa -modulus -noout -in $KEY | openssl md5|awk '{print$2}'; done
```

*example output*
<pre>
Key: ./amazon.com.key
Private-Key: (2048 bit)
Key hash: 85c4dc0fdcf551dea9da8759bbb2fe94

Key: ./google.com.key
Private-Key: (2048 bit)
Key hash: d39cf6b9b28778666006a41d712fb296
</pre>

**CSR: Display all certificate signing requests - subject, signature algorithm, modulus md5 sum (recursive)**

```
for CSR in $(grep -lrs '\-BEGIN CERTIFICATE REQUEST\-' .);do echo; echo "CSR:" $CSR; CERTV=$(openssl req -text -noout -in $CSR);echo -n "Subject: ";echo "$CERTV"|grep -i [S]ubject:|cut -d ':' -f 2;echo "$CERTV"|grep -i [S]ignature\ [A]lgorithm|head -1|awk '{gsub(/^ +| +$/,"")}1';echo -n "CSR hash: ";openssl req -noout -modulus -in $CSR|openssl md5|awk '{print $2}';done
```


*example output*
<pre>
CSR: ./mycompany.com.csr
Subject:  C=US, ST=Washington, L=Seattle, O=Company, CN=mycompany.com
Signature Algorithm: sha256WithRSAEncryption
CSR hash: 85c4dc0fdcf551dea9da8759bbb2fe94
</pre>

**Download certificate from remote host**

```
HOST=google.com
openssl s_client -connect $HOST:443 </dev/null 2>/dev/null| sed -n '/-BEGIN CERTIFICATE-/,/-END CERTIFICATE-/p'
```