#!/bin/bash

## For remote Controlling CRDB Servers
#   crdb is cockroachdb a distributive SQL database

# Vars
service="cockroachdb"
# example:
#  ssh user@server 'bash -s' < crdb.sh restart securecockroachdb
#      "securecockroachdb" is example used if $service is different
#
# example:
#   ssh user@server << 'ENDSSH'
#        sudo -- bash -c "cmd"
#        sudo -- bash -c "another cmd"
#   ENDSSH

CRDB="cockroach --certs-dir=/var/lib/cockroach/certs"
CRDB_VERSION_NEW="v21.1"
CRDB_VERSION_OLD="20.1"

if [ ! -z "$2" ]; then 
    service=($2)
fi

function restart() {
    sudo systemctl restart ${service}
}

function check() {
    if (sudo systemctl -q is-active ${service}); then
        echo "${service} is running"
    else
        echo "${service} is not running"
    fi    
}

function disable_finalize() {
    echo "Disabling CRDB Finalization of Upgrade"
    ${CRDB} sql --execute "SET CLUSTER SETTING cluster.preserve_downgrade_option = '${CRDB_VERSION_OLD}'"

}

function install() {
    echo "Replacing the syslink with the new CRDB version and restarting"
    sudo ln -sfn /opt/cockroach-${CRDB_VERSION_NEW}.linux-amd64/cockroach /usr/local/bin/cockroach
    sudo systemctl restart ${service}
}


case "$1" in 
    restart)
        restart
        ;;
    check)
        check
        ;;
    upgrade)
        install replace_restart
        ;;
    disable_finalize)
        disable_finalize
        ;;
    install)
        install
        ;;
    replace_restart)
        replace_restart
        ;;
    *)
        echo "no command passed"
        ;;
esac

