#!/usr/bin/env bash

function die() {
    echo -e "$RED ERROR - $*$NO_COLOR"
    return 1
}

function log_info() {
    echo -e "$CYAN$*$NO_COLOR"
}

function log_success() {
    echo -e "$GREEN$*$NO_COLOR"
}

function wait_until_started() {
    service_name="$1"
    port="$2"
    retries="$3"

    log_info "Checking to see if $service_name at localhost:$port is responding..."

    for (( i = 0; i < retries; i++ )); do
        if nc -z localhost "$port"; then
            log_success "$service_name is up!"
            return 0
        fi
        sleep 3
    done

    die "Couldn't find $service_name responding on port $port after $retries retries"
}
