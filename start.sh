#!/bin/sh
if [ -r /etc/stunnel/stunnel.conf ]; then
  echo "stunnel.conf already exists, skipping copy"
else
  cp /opt/stunnel.conf.modified /etc/stunnel/stunnel.conf
fi

if [ -r /etc/lighttpd/lighttpd.conf ]; then
  echo "lighttpd.conf already exists, skipping copy"
else
  cp /opt/lighttpd.conf.modified /etc/lighttpd/lighttpd.conf
fi

if [ -r /etc/ssl/certs/ca-certificates.crt ]; then
  echo "ca-certificates.crt already exists, skipping copy"
else
  cp /opt/ca-certificates.crt.original /etc/ssl/certs/ca-certificates.crt
fi

while [ ! -r /etc/stunnel/google-ldap-client.crt ] || [ ! -r /etc/stunnel/google-ldap-client.key ]; do
  echo "Waiting for google-ldap-client.crt and google-ldap-client.key to be copied into /etc/stunnel"
  sleep 1
done
chmod 600 /etc/stunnel/google-ldap-client.*

if [ ! -d /etc/lighttpd/ssl/ ]; then
  mkdir -p /etc/lighttpd/ssl/
fi


if [ -r /etc/lighttpd/ssl/localhost.pem ]; then
  echo 'lighttpd Cert already exists, skipping generation'
else
  echo "lighttpd Cert doesn't exist, generation self signed..."
  openssl req -x509 -newkey rsa:4096 -keyout /tmp/key.pem -out /tmp/cert.pem -days 365 -subj '/CN=localhost' -nodes -sha256
  cat /tmp/key.pem /tmp/cert.pem > /etc/lighttpd/ssl/localhost.pem
fi

if [ -r /etc/stunnel/stunnel.pem ]; then
  echo 'stunnel Cert already exists, skipping generation'
else
  echo "stunnel Cert doesn't exist, generation self signed..."
  openssl req -x509 -newkey rsa:4096 -keyout /tmp/key.pem -out /tmp/cert.pem -days 365 -subj '/CN=localhost' -nodes -sha256
  cat /tmp/key.pem /tmp/cert.pem > /etc/stunnel/stunnel.pem
fi

chmod 600 /etc/lighttpd/ssl/localhost.pem
chmod 600 /etc/stunnel/stunnel.pem
rm /tmp/key.pem /tmp/cert.pem 2>/dev/null

/usr/bin/stunnel /etc/stunnel/stunnel.conf