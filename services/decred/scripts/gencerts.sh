#!/usr/bin/env bash

openssl ecparam -name secp521r1 -genkey -out dcrd.key

openssl req -new -out dcrd.csr -key dcrd.key -config ./openssl-decred.cnf -subj "/CN=dcrd cert"

openssl req -text -noout -in dcrd.csr

openssl x509 -req -days 36500 -in dcrd.csr -signkey dcrd.key -out dcrd.cert -extensions v3_req -extfile ./openssl-decred.cnf

openssl x509 -text -in dcrd.cert



openssl ecparam -name secp521r1 -genkey -out dcrw.key

openssl req -new -out dcrw.csr -key dcrw.key -config ./openssl-decred.cnf -subj "/CN=dcrw cert"

openssl req -text -noout -in dcrw.csr

openssl x509 -req -days 36500 -in dcrw.csr -signkey dcrw.key -out dcrw.cert -extensions v3_req -extfile ./openssl-decred.cnf

openssl x509 -text -in dcrw.cert