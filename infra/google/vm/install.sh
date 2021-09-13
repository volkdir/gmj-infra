#!/bin/sh
# set ip
echo set IP
IP=$(curl -H "Metadata-Flavor: Google" http://169.254.169.254/computeMetadata/v1/instance/network-interfaces/0/access-configs/0/external-ip )
docker run --rm curlimages/curl:7.74.0 -L -vvv "https://carol.selfhost.de/update?username=460881&password=3GLiebArno&myip=$IP"

mkdir /opt/jitsi 
cd /opt/jitsi
echo clone jitsi
git clone -b stable-5142-3 https://github.com/jitsi/docker-jitsi-meet.git .

cat << EOT0 >> /opt/jitsi/.env
JICOFO_COMPONENT_SECRET=865ad711465dcca1f1a9d5d70d982fac
JICOFO_AUTH_PASSWORD=04feee1c8ea357f1e747a3eaae6d5f02
JVB_AUTH_PASSWORD=88771419d763afdbdf6f09d35ce7f4a7
JIGASI_XMPP_PASSWORD=d08f4f2197a8ce7f0f6bddfce8b606ae
JIBRI_RECORDER_PASSWORD=193fecf4ad66740588b617ae435e1683
JIBRI_XMPP_PASSWORD=081085c37e633dfd558cc0112d719f1b
CONFIG=~/.jitsi-meet-cfg
HTTP_PORT=80
HTTPS_PORT=443
TZ=UTC
PUBLIC_URL=https://rrh.selfhost.eu
#PUBLIC_URL=https://volkdir.dyndnss.net/
ENABLE_PREJOIN_PAGE=1
ENABLE_LETSENCRYPT=1
LETSENCRYPT_DOMAIN=rrh.selfhost.eu
LETSENCRYPT_EMAIL=volkdir@hotmail.de
ETHERPAD_TITLE="Video Chat"
ETHERPAD_DEFAULT_PAD_TEXT="Welcome to Web Chat!\n\n"
ETHERPAD_SKIN_NAME="colibris"
ETHERPAD_SKIN_VARIANTS="super-light-toolbar super-light-editor light-background full-width-editor"
XMPP_DOMAIN=meet.jitsi
XMPP_SERVER=xmpp.meet.jitsi
XMPP_BOSH_URL_BASE=http://xmpp.meet.jitsi:5280
XMPP_AUTH_DOMAIN=auth.meet.jitsi
XMPP_MUC_DOMAIN=muc.meet.jitsi
XMPP_INTERNAL_MUC_DOMAIN=internal-muc.meet.jitsi
XMPP_GUEST_DOMAIN=guest.meet.jitsi
XMPP_MODULES=
XMPP_MUC_MODULES=
XMPP_INTERNAL_MUC_MODULES=
JVB_BREWERY_MUC=jvbbrewery
JVB_AUTH_USER=jvb
JVB_STUN_SERVERS=meet-jit-si-turnrelay.jitsi.net:443
JVB_PORT=10000
JVB_TCP_HARVESTER_DISABLED=true
JVB_TCP_PORT=4443
JVB_TCP_MAPPED_PORT=4443
JICOFO_AUTH_USER=focus
JIGASI_XMPP_USER=jigasi
JIGASI_BREWERY_MUC=jigasibrewery
JVB_AUTH_USER=jvb
JVB_STUN_SERVERS=meet-jit-si-turnrelay.jitsi.net:443
JVB_PORT=10000
JVB_TCP_HARVESTER_DISABLED=true
JVB_TCP_PORT=4443
JVB_TCP_MAPPED_PORT=4443
JICOFO_AUTH_USER=focus
JIGASI_XMPP_USER=jigasi
JIGASI_BREWERY_MUC=jigasibrewery
JIGASI_PORT_MIN=20000
JIGASI_PORT_MAX=20050
XMPP_RECORDER_DOMAIN=recorder.meet.jitsi
JIBRI_RECORDER_USER=recorder
JIBRI_RECORDING_DIR=/config/recordings
JIBRI_FINALIZE_RECORDING_SCRIPT_PATH=/config/finalize.sh
JIBRI_XMPP_USER=jibri
JIBRI_BREWERY_MUC=jibribrewery
JIBRI_PENDING_TIMEOUT=90
JIBRI_STRIP_DOMAIN_JID=muc
JIBRI_LOGS_DIR=/config/logs
RESTART_POLICY=unless-stopped
EOT0

echo gen password
./gen-passwords.sh
mkdir -p ~/.jitsi-meet-cfg/{web/letsencrypt,transcripts,prosody/config,prosody/prosody-plugins-custom,jicofo,jvb,jigasi,jibri}
docker-compose up -d
