FROM alpine:latest
# as BUILD

RUN apk add --no-cache --update \
    vim \
    'lighttpd=1.4.67-r0' 'stunnel=5.66-r0' 'openssl=3.0.7-r0' 'openldap-clients=2.6.3-r6'

COPY start.sh test.sh stunnel.conf lighttpd.conf /

RUN mv /etc/stunnel/stunnel.conf /opt/stunnel.conf.original && \
  mv /etc/lighttpd/lighttpd.conf /opt/lighttpd.conf.original && \
  mv /stunnel.conf /opt/stunnel.conf.modified && \
  mv /lighttpd.conf /opt/lighttpd.conf.modified && \
  mv /etc/ssl/certs/ca-certificates.crt /opt/ca-certificates.crt.original && \
  mv /start.sh /opt/start.sh && \
  mv /test.sh /opt/test.sh && \
  chmod 700 /opt/start.sh && \
  chmod 700 /opt/test.sh

# RUN mkdir /etc/lighttpd/ssl/ && \
# 	openssl req -x509 -newkey rsa:4096 -keyout /tmp/key.pem -out /tmp/cert.pem -days 365 -subj '/CN=localhost' -nodes -sha256 && \
# 	cat /tmp/key.pem /tmp/cert.pem > /etc/lighttpd/ssl/localhost.pem && \
# 	cat /tmp/key.pem /tmp/cert.pem > /etc/stunnel/stunnel.pem && \
# 	chmod 600 /etc/lighttpd/ssl/localhost.pem && \
#   chmod 600 /etc/stunnel/stunnel.pem && \
# 	rm /tmp/key.pem /tmp/cert.pem

# COPY shell.sh stunnel.conf lighttpd.conf Google_2025_12_13_78346.crt Google_2025_12_13_78346.key ssl.conf /
# RUN mv /shell.sh /usr/local/bin/shell.sh && \
#   mv /stunnel.conf /etc/stunnel/stunnel.conf && \
#   mv /Google_2025_12_13_78346.crt /etc/stunnel/google-ldap-client.crt && \
#   mv /Google_2025_12_13_78346.key /etc/stunnel/google-ldap-client.key && \
#   chmod 600 /etc/stunnel/google-ldap-client.* && \
#   mv /lighttpd.conf /etc/lighttpd/lighttpd.conf && \
#   mv /ssl.conf /etc/lighttpd/ssl.conf && \
#   chmod 777 /usr/local/bin/shell.sh && \
#   mkdir -p /var/www/html/upload && \
#   echo "titi" > /var/www/html/upload/toto.txt

HEALTHCHECK --interval=10s --timeout=5s \
  CMD /opt/test.sh || exit 1
  # CMD curl -f http://localhost/ || exit 1

VOLUME /etc/ssl/certs/ /etc/stunnel/ /etc/lighttpd/ /var/www/html/
EXPOSE 80 443 1636

# ENTRYPOINT ["/usr/sbin/lighttpd", "-D", "-f", "/etc/lighttpd/lighttpd.conf"]
# ENTRYPOINT ["/usr/bin/stunnel", "/etc/stunnel/stunnel.conf"]
# CMD sleep infinity
ENTRYPOINT ["/opt/start.sh"]