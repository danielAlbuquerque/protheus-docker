#!/bin/bash

cp /build/odbc.ini /etc/odbc.ini
cp /build/my-init.sh /usr/local/bin

odbcinst -i -s -l -f /etc/odbc.ini

echo "/opt/totvs/dbaccess64/multi/" > /etc/ld.so.conf.d/dbaccess64-libs.conf
/sbin/ldconfig

chmod +x /opt/totvs/dbaccess64/dbmonitor
chown -R root:root /opt/totvs

rm -rf /build
