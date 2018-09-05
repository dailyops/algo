#!/usr/bin/env bash
set -ex
# ref https://github.com/trailofbits/algo#deploy-the-algo-server
# run this on a working station(recommend ubuntu18.04)
# trigger installation process on cloud provider, eg. gce
algo_server=${1:-algo}
echo server: $algo_server

# python 2 required
sudo apt install -y python

## zip package way
#sudo apt install -y unzip
#wget https://github.com/trailofbits/algo/archive/master.zip
#unzip master.zip
#cd algo-master

## git dist 
#git clone https://github.com/trailofbits/algo.git
#cd algo

# core dependency
sudo apt-get update && sudo apt-get install \
    build-essential \
    libssl-dev \
    libffi-dev \
    python-dev \
    python-pip \
    python-setuptools \
    python-virtualenv -y

# extra dependency
python -m virtualenv --python=`which python2` env &&
    source env/bin/activate &&
    python -m pip install -U pip &&
    python -m pip install -r requirements.txt

## install way1
# ./algo

## install way2
# source env/bin/activate && ansible-playbook main.yml $@
## update users
# source env/bin/activate && ansible-playbook users.yml -t update-users $@

# customize
# -v -vvv -vvvv
# ansible-playbook --verbose --tags=a,b --extra-vars='name=geek age=3'
# set additional variables as key=value or YAML/JSON, if filename prepend with @

## google gce
ansible-playbook main.yml -vvv -e "provider=gce
  server_name=${algo_server}
  ondemand_cellular=true
  ondemand_wifi=true
  ondemand_wifi_exclude=test
  local_dns=true
  ssh_tunneling=true
  windows=false
  store_cakey=true
  region=asia-east1-b
  gce_credentials_file=~/gcp-service-account.json"

## todo
# * ip frozen or domain name
# - mtu mss fixed
# - gcp region
# - gce credential file

echo ==congrats to setup ${algo_server} vpn!
echo ==save your configs at your hand!
