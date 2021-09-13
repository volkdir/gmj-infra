#!/bin/sh
echo set IP
IP=$(curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip )
#curl "https://carol.selfhost.de/update?username=460881&password=3GLiebArno&myip=$IP"
#curl  "https://dyndnss.net/?user=volkdir&pass=71907594&domain=volkdir&updater=other"
docker run --rm curlimages/curl:7.74.0 -L -vvv "https://carol.selfhost.de/update?username=460881&password=3GLiebArno&myip=$IP"
sleep 30
mkdir /opt/bbb
cd /opt/bbb
echo install bbb
wget -qO- https://ubuntu.bigbluebutton.org/bbb-install.sh | bash -s -- -w -a -v xenial-22 -s rrh.selfhost.eu -g -e volkdir@hotmail.de
