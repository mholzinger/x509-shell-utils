
# For loop to look for every certificate in a directory recusrsively
for CERT in $(grep -lrs '\-BEGIN CERTIFICATE\-' .);
do echo;

  # Print out certificate name
  echo "Cert:" $CERT;

  # Capture the decoded certificate value
  DECODED_CERT=$(openssl x509 -text -noout -in $CERT);

  # Print Subject Field
  echo -n "Subject: ";
  echo "$DECODED_CERT"|grep -i [S]ubject:|cut -d ':' -f 2;

  # Print Issuer date (just the year)
  echo -n "Issuer Date: ";
  echo "$DECODED_CERT"|grep -i [B]efore|awk '{print $6}';

  # Print full expiration date
  echo "$DECODED_CERT"|grep -i [A]fter|sed 's/Not\ After\ :/Expire Date:/g'|awk '{gsub(/^ +| +$/,"")}1';

  # Print signature algorithm version
  echo "$DECODED_CERT"|grep -i [S]ignature\ [A]lgorithm|head -1|awk '{gsub(/^ +| +$/,"")}1';

  # Print SHA1 Certificate Fingerprint
  openssl x509 -noout -in $CERT -fingerprint|sed 's/SHA1\ Fingerprint=/Fingerprint: /g';

  # Print MD5 Modulus
  echo -n "Cert hash: ";
  openssl x509 -noout -modulus -in $CERT|openssl md5|awk '{print $2}';
done

