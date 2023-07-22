#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#if use self-signed sertificates
#NODE_EXTRA_CA_CERTS=
#export NODE_EXTRA_CA_CERTS

#debug
#set -x

#fail_on_errors
set -e

#if want interactive
INTERACTIVE="0"
#path to backup
PATH_TO_BACKS=""
ITER_VALUE="100000"
EXPORT_PREFIX="ex_"
BW_EMAIL_DEFAULT=""
BW_PASS_DEFAULT=""
BW_SERVERE=""

if [[ "$INTERACTIVE" == 1 ]]; then
    echo -n "Enter email  : "
    read -r BW_EMAIL
    echo -n "Enter password : "
    read -rs BW_PASS
fi

BW_PASS="${BW_PASS:-"$BW_PASS_DEFAULT"}"
BW_EMAIL="${BW_EMAIL:-"$BW_EMAIL_DEFAULT"}"
bw config server "$BW_SERVERE" --raw --response
#bw status --response
BW_SESSION="$(bw login "$BW_EMAIL" "$BW_PASS" --raw)"
export BW_SESSION
#bw status --response
TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
OUTPUT_FILE=$EXPORT_PREFIX$TIMESTAMP.enc
bw export --raw "$BW_PASS" --format json |
    openssl enc -aes-256-cbc -pbkdf2 -salt -k "$BW_PASS" -out "$PATH_TO_BACKS$OUTPUT_FILE" -iter "$ITER_VALUE"
bw logout --response
unset NODE_EXTRA_CA_CERTS
unset BW_SESSION
