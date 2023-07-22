#!/bin/bash
PATH=/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin

#if use self-signed sertificates
#NODE_EXTRA_CA_CERTS=
#export NODE_EXTRA_CA_CERTS

#debug
#set -x

#fail_on_errors
set -e

#db_credentials
PGDATABASE=""
PGHOST=""
PGPORT=""
PGUSER=""
PGPASSWORD=""
#app_credentials
BW_SERVERE=""
BW_ACCOUNT=""
BW_PASS=""
ORG_ID=""
ITER_VALUE="10000000"
#paths
PATH_TO_BACKUP="/vaultwarden/backup/"
PATH_TO_APP="/vaultwarden/data/"
#prefix
EXPORT_OUTPUT_PREFIX="export_"
DUMP_OUTPUT_PREFIX="dump_"
ZIP_OUTPUT_PREFIX="backup_"

TIMESTAMP=$(date "+%Y-%m-%d_%H-%M")
LOG_FILE="log_$TIMESTAMP.log"

function bw_connect {
    bw config server "$BW_SERVERE" --response
    printf "\n"
    bw status --response
    BW_SESSION="$(bw login "$BW_ACCOUNT" "$BW_PASS" --raw)"
    printf "\n"
    export BW_SESSION
    bw status --response
    printf "\n"
}

function bw_logout {

    bw logout --response
    printf "\n"
    bw status --response
    printf "\n"
    unset BW_SESSION
}

function bw_get_json {
    OUTPUT_EX="$EXPORT_OUTPUT_PREFIX$TIMESTAMP.encrypted"
    bw export "$BW_PASS" --organizationid "$ORG_ID" --raw --format json \
    | openssl enc -aes-256-cbc -pbkdf2 -salt -k "$BW_PASS" -out "/vault/vaultwarden/backup/$OUTPUT_EX" -iter "$ITER_VALUE" && printf "Success, encrypted export aes-256-cbc\n"
}

function bw_pg_dump {
    OUTPUT_DUMP="$DUMP_OUTPUT_PREFIX$TIMESTAMP.dump"
    export PGDATABASE PGHOST PGPORT PGUSER PGPASSWORD
    pg_dump -f "$PATH_TO_BACKUP$OUTPUT_DUMP" && printf "Success, dump created\n"
    unset PGDATABASE PGHOST PGPORT PGUSER PGPASSWORD
}

function bw_zip_actions {
    cd "${PATH_TO_BACKUP:?}" && zip -r "$ZIP_OUTPUT_PREFIX$TIMESTAMP.zip" "$OUTPUT_EX" "$OUTPUT_DUMP" "$LOG_FILE" "$PATH_TO_APP"
    rm "${PATH_TO_BACKUP:?}${OUTPUT_EX:?}" "${PATH_TO_BACKUP:?}${OUTPUT_DUMP:?}" "${PATH_TO_BACKUP:?}${LOG_FILE:?}"
}

function main {
    bw_connect
    bw_get_json
    bw_logout
    bw_pg_dump
    bw_zip_actions
    find "${PATH_TO_BACKUP:?}" -mtime +3 -delete
}

main >"$PATH_TO_BACKUP$LOG_FILE"
