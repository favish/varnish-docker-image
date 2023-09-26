#!/bin/sh
set -e

# Make sure the varnish cache storage location exists on the filesystem
mkdir -p /var/lib/varnish/`hostname` && chown nobody /var/lib/varnish/`hostname`

varnishd -s malloc,$VARNISH_MALLOC \
  -p send_timeout=$VARNISH_SEND_TIMEOUT \
  -p http_resp_hdr_len=16k \
  -p feature=+http2 \
  -a :80 \
  -f /etc/varnish/default.vcl \
  -S /etc/varnish/secret \
  -T 127.0.0.1:6082
sleep 2
varnishncsa & prometheus_varnish_exporter
