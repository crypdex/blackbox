#!/usr/bin/env bash

openssl ecparam -name secp521r1 -genkey -out dcrd.key

openssl req -new -out dcrd.csr -key dcrd.key -config ./openssl-decred.cnf -subj "/CN=dcrd cert"

#openssl req -text -noout -in dcrd.csr

openssl x509 -req -days 36500 -in dcrd.csr -signkey dcrd.key -out dcrd.cert -extensions v3_req -extfile ./openssl-decred.cnf

#openssl x509 -text -in dcrd.cert



openssl ecparam -name secp521r1 -genkey -out dcrwallet.key

openssl req -new -out dcrwallet.csr -key dcrwallet.key -config ./openssl-decred.cnf -subj "/CN=dcrd cert"

#openssl req -text -noout -in dcrd.csr

openssl x509 -req -days 36500 -in dcrwallet.csr -signkey dcrwallet.key -out dcrwallet.cert -extensions v3_req -extfile ./openssl-decred.cnf

#openssl x509 -text -in dcrd.cert