#!/bin/sh -e

# download curl and ca-certificate from apt-get if needed
to_install=""

if [ $(dpkg-query -W -f='${Status}' curl 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  to_install="curl"
fi

if [ $(dpkg-query -W -f='${Status}' ca-certificates 2>/dev/null | grep -c "ok installed") -eq 0 ]; then
  to_install="$to_install ca-certificates"
fi

if [ -n "$to_install" ]; then
  LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends $to_install
fi

LC_ALL=C DEBIAN_FRONTEND=noninteractive apt-get install -y --no-install-recommends openssl jq

curl -o /usr/sbin/cfssl -SL  https://github.com/docker-ppc64le/docker-light-baseimage/raw/stable/assets/cfssl
chmod 700 /usr/sbin/cfssl

curl -o /usr/sbin/cfssljson -SL  https://github.com/docker-ppc64le/docker-light-baseimage/raw/stable/assets/cfssljson
chmod 700 /usr/sbin/cfssljson

# remove tools installed to download cfssl
if [ -n "$to_install" ]; then
  apt-get remove -y --purge --auto-remove $to_install
fi

exit 0
