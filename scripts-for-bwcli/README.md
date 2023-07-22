For these scripts to work bw_cli needed

* backup-personal-vault.sh

This script can backup personal vault by bw_cli interactively or by cronjob
Also check variables in scripts

* backup-organization-vault.sh

This script can backup organization vault by bw_cli and pg_dump
Also check variables in scripts

0 3 * * * /vault/backup-personal-vault.sh