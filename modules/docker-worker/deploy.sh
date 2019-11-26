#!/bin/bash -vx

set -vex

export DEBIAN_FRONTEND=noninteractive 
export V4L2LOOPBACK_VERSION=0.12.0
export PAPERTRAIL=logs2.papertrailapp.com:22395
dw_dir=/home/worker/docker-worker/

apt-get update
apt-get upgrade -yq
apt-get install -yq \
  curl \
  apt-transport-https \
  ca-certificates \
  curl \
  software-properties-common \
  git \
  rng-tools 

echo `which nologin` >> /etc/shells
useradd -m -s `which nologin` worker
usermod -L worker

groupadd -f docker
git clone git://github.com/taskcluster/docker-worker $dw_dir
cd $dw_dir
git checkout origin/release

curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
apt-key fingerprint 0EBFCD88J && add-apt-repository \
  "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"

apt-get install -yq \
  dh-python \
  dkms \
  linux-headers-generic \
  linux-image-generic \
  linux-headers-$(uname -r) \
  python3-systemd \
  build-essential \
  cdbs \
  docker-ce=18.06.0~ce~3-0~ubuntu \
  git-core \
  gstreamer1.0-alsa \
  gstreamer1.0-plugins-bad \
  gstreamer1.0-plugins-base \
  gstreamer1.0-plugins-good \
  gstreamer1.0-plugins-ugly \
  gstreamer1.0-tools \
  jq \
  liblz4-tool \
  lvm2 \
  openvpn \
  pbuilder \
  python-configobj \
  python-dev \
  python-mock \
  python-pip \
  python3-dev \
  python3-pip \
  rsyslog-gnutls \
  python-statsd

bash -vex $dw_dir/deploy/packer/base/scripts/configure_syslog.sh

git clone git://github.com/facebook/zstd /tmp/zstd
cd /tmp/zstd
git checkout f3a8bd553a865c59f1bd6e1f68bf182cf75a8f00
make zstd
mv zstd /usr/bin

cd /lib/modules
export KERNEL_VER=$(ls -1 | tail -1)
cd /usr/src
git clone --branch v${V4L2LOOPBACK_VERSION} \
	  git://github.com/umlaeute/v4l2loopback.git v4l2loopback-${V4L2LOOPBACK_VERSION}
cd v4l2loopback-${V4L2LOOPBACK_VERSION}
dkms install -m v4l2loopback -v ${V4L2LOOPBACK_VERSION} -k ${KERNEL_VER}
dkms install -m v4l2loopback -v ${V4L2LOOPBACK_VERSION} -k `uname -r`

echo 'v4l2loopback' | tee --append /etc/modules
echo 'options v4l2loopback devices=100' > /etc/modprobe.d/v4l2loopback.conf
echo 'snd-aloop' | tee --append /etc/modules
echo 'options snd-aloop enable=1,1,1,1,1,1,1,1 index=0,1,2,3,4,5,6,7' > /etc/modprobe.d/snd-aloop.conf
echo '#!/bin/sh -e' > /etc/rc.local
echo 'modprobe snd-aloop' >> /etc/rc.local
echo 'exit 0' >> /etc/rc.local
chmod +x /etc/rc.local
echo "net.ipv4.tcp_challenge_ack_limit = 999999999" >> /etc/sysctl.conf

cat > $dw_dir/deploy/deploy.json <<EOF
{
  "debug.level": "",
  "sslKeyLocation": "/tmp/docker-worker-secrets/taskcluster-net/docker-worker-cert.key",
  "cotEd25519SigningKey": "/tmp/docker-worker-secrets/taskcluster-net/docker-worker-cot-ed25519-signing.key",
  "papertrail": "logs2.papertrailapp.com:22395"
}
EOF

pip install zstandard
pip3 install zstandard taskcluster
apt-get purge -yq apport

curl -o /etc/papertrail-bundle.pem https://papertrailapp.com/tools/papertrail-bundle.pem
bash -vex /home/worker/docker-worker/deploy/packer/base/scripts/node.sh
npm i -g yarn

cd $dw_dir
yarn install --frozen-lockfile
make -j4 -C deploy deploy.tar.gz
tar -xzvf $dw_dir/deploy/deploy.tar.gz -C / --strip-components=1

curl --fail -L -o /usr/local/bin/start-worker \
  https://github.com/taskcluster/taskcluster-worker-runner/releases/download/v0.6.0/start-worker-linux-amd64
chmod +x /usr/local/bin/start-worker

systemctl enable docker-worker

/lib/systemd/set-cpufreq
systemctl restart syslog
cp /tmp/docker.service /lib/systemd/system/
systemctl daemon-reload
systemctl restart docker
modprobe snd-aloop
modprobe v4l2loopback
python3 /usr/local/bin/load-packet.py
systemctl start docker-worker.service
systemctl status --no-pager docker-worker.service
