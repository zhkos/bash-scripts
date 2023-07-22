#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#if use self-signed sertificates
#NODE_EXTRA_CA_CERTS=
#export NODE_EXTRA_CA_CERTS

#debug
#set -x

#fail_on_errors
set -e

#app_credentials
BW_EMAIL_DEFAULT=""
BW_PASS_DEFAULT=""
BW_SERVERE=""
#if want interactive
INTERACTIVE="0"
#path to backup
PATH_TO_BACKUP=""
ITER_VALUE="10000000"
EXPORT_PREFIX="ex_"

TIMESTAMP=$(date "+%Y%m%d-%H%M%S")
OUTPUT_EX="$EXPORT_PREFIX$TIMESTAMP.encrypted"

function pass_interactive_input {
    if [[ "$INTERACTIVE" == 1 ]]; then
        echo -n "Enter email  : "
        read -r BW_EMAIL
        echo -n "Enter password : "
        read -rs BW_PASS
    fi
}

function defaults_check {
    BW_PASS="${BW_PASS:-"$BW_PASS_DEFAULT"}"
    BW_EMAIL="${BW_EMAIL:-"$BW_EMAIL_DEFAULT"}"
}

function bw_connect {
    bw config server "$BW_SERVERE" --raw --response
    #bw status --response
    BW_SESSION="$(bw login "$BW_EMAIL" "$BW_PASS" --raw)"
    export BW_SESSION
    #bw status --response
}

function bw_get_json {
    bw export --raw "$BW_PASS" --format json \
    | openssl enc -aes-256-cbc -pbkdf2 -salt -k "$BW_PASS" -out "${PATH_TO_BACKUP:?}$OUTPUT_EX" -iter "$ITER_VALUE" \
    && printf "Success, encrypted export aes-256-cbc\n"
    bw logout --response
    unset NODE_EXTRA_CA_CERTS
    unset BW_SESSION
}

function main {
    pass_interactive_input
    defaults_check
    bw_connect
    bw_get_json
}

main
