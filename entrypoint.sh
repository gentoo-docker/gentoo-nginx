#!/bin/bash

echo "MAKEOPTS=\"-j$(nproc)\"" > /etc/portage/cpu.comf
sed -i "s/worker_processes 1;/worker_processes $(nproc);/" /etc/nginx/nginx.conf

exec "$@"
