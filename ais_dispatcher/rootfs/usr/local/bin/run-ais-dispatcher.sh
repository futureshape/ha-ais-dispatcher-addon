#!/usr/bin/env bash
set -euo pipefail

log() {
    local level="$1"; shift
    printf '%s [%s] %s\n' "$(date --iso-8601=seconds)" "${level}" "$*"
}

LOG_LEVEL="${LOG_LEVEL:-info}"
log INFO "AIS Dispatcher startup (log level: ${LOG_LEVEL})"

install_dir="/usr/share/aisdispatcher"
data_dir="/data/ais"

mkdir -p "${data_dir}"

if [ ! -f "${data_dir}/.installed" ]; then
    log INFO "First run detected; seeding vendor files"
    cp -a "${install_dir}/." "${data_dir}/"
    touch "${data_dir}/.installed"
else
    log INFO "Existing data detected; refreshing vendor binaries"
    for dir in bin lib htdocs update_cache; do
        log INFO "Refreshing ${dir}"
        rm -rf "${data_dir}/${dir}"
        cp -a "${install_dir}/${dir}" "${data_dir}/"
    done
    for template in aiscontrol.cfg aisdispatcher.json; do
        if [ ! -f "${data_dir}/etc/${template}" ]; then
            log INFO "Restoring missing template ${template}"
            cp -a "${install_dir}/etc/${template}" "${data_dir}/etc/${template}"
        fi
    done
fi

if [ -d /home/ais ] && [ ! -L /home/ais ]; then
    log INFO "Removing stale /home/ais directory"
    rm -rf /home/ais
fi
ln -sfn "${data_dir}" /home/ais
log INFO "Linked /home/ais -> ${data_dir}"

if /bin/bash /home/ais/bin/link_binary >/tmp/link_binary.log 2>&1 ; then
    log INFO "link_binary completed successfully"
else
    status=$?
    log WARN "link_binary exited with status ${status}"
    while IFS= read -r line; do
        log WARN "link_binary: ${line}"
    done < /tmp/link_binary.log
fi
rm -f /tmp/link_binary.log

chown -R ais:ais "${data_dir}"
log INFO "Ownership set on ${data_dir}"

export HOME=/home/ais
export LD_LIBRARY_PATH=/home/ais/lib
export PATH="/home/ais/bin:${PATH}"
export LOG_LEVEL

log INFO "Starting AIS Dispatcher UI"
exec /usr/sbin/gosu ais /home/ais/bin/aiscontrol
