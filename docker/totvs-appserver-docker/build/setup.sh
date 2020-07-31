#!/usr/bin/env bash
set -e
set -x

TOTVS_PATH=/totvs12

mkdir -p $TOTVS_PATH/protheus/{apo,bin/appserver}

cd $TOTVS_PATH/protheus/bin/appserver/

chmod 777 $TOTVS_PATH/protheus/bin/appserver/*.so

echo $TOTVS_PATH/"protheus/bin/appserver/" > /etc/ld.so.conf.d/appserver64-libs.conf
/sbin/ldconfig

cp /build/my-init.sh /usr/local/bin/my-init.sh
cp /build/appserver.ini $TOTVS_PATH/protheus/bin/appserver/

rm -rf /build
