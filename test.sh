#!/bin/sh
timeout 3s ldapsearch -x -H ldap://localhost:1636 -b "dc=aspyr,dc=com" '(mail=daniel@aspyr.com)'