#!/bin/sh

ip4=$(curl -s https://www.cloudflare.com/ips-v4)
ip6=$(curl -s https://www.cloudflare.com/ips-v6)

echo -n $ip4 $ip6
