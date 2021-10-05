#!/bin/bash

#######################
# Setup and Controller for Prometheus on VM 
#
#######################

## Vars
#host dn|ip for the vm host of the prometheus instance
host=""
#user for ssh login
user=""
prometheus_version="2.30.2"
prometheus_config_url=""
prometheus_serviceunit_url=""

function create_service_user() {
    sudo groupadd --system prometheus
    sudo useradd -s /sbin/nologin --system -g prometheus prometheus
}

function copy_prometheus_to_bin() {
    curl -LO https://github.com/prometheus/releases/download/v${prometheus_version}/prometheus-${prometheus_version}.linux-amd64.tar.gz
    tar xvf prometheus-${prometheus_version}.linux-amd64.tar.gz
    cd prometheus-${prometheus_version}.linux-amd64
    sudo mv prometheus /usr/local/bin/
    sudo chmod 0755 /usr/local/bin/prometheus
    sudo chown prometheus:prometheus /usr/local/bin/prometheus
}

function delete_prometheus_temp() {
    sudo rm -rf prometheus-${prometheus_version}.linux-amd64
}

function create_storage_dir() {
    sudo mkdir -p /var/lib/prometheus
    sudo chmod 755 /var/lib/prometheus
    sudo chown prometheus:prometheus /var/lib/prometheus
}

function setup_prometheus_config() {
    curl -LJO ${prometheus_config_url}
    sudo mkdir -p /etc/prometheus
    sudo mv prometheus.yml /etc/prometheus/
    sudo chmod 755 /etc/prometheus/prometheus.yml
}

function setup_prometheus_service() {
    curl -LJO ${prometheus_serviceunit_url}
    sudo mv prometheus.service /etc/systemd/system/
}

## Handlers for prometheus service

function systemd_daemon_reload() {
    sudo systemctl daemon-reload
}

function start_prometheus_service() {
    sudo systemctl start prometheus.service
}

function enable_prometheus_service() {
    sudo systemctl enable prometheus.service
}

function restart_prometheus_service() {
    sudo systemctl restart prometheus.service
}

function setup() {
    copy_prometheus_to_bin
    create_service_user
    delete_prometheus_temp
    create_storage_dir

    setup_prometheus_config
    setup_prometheus_service
    systemd_daemon_reload
    start_prometheus_service
    enable_prometheus_service
}

case "$1" in 
    setup)
        setup
        ;;
    *)
        echo "no command passed"
        ;;
esac

