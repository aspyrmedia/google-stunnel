#!/bin/bash
docker-compose exec -ti google-stunnel-ldap ldapsearch -x -H ldap://localhost:1636 -b "dc=aspyr,dc=com" '(mail=dhagen@aspyr.com)'