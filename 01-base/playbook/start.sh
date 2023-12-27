#!/bin/bash
cd "$(dirname "$0")"

mkdir ./ubuntu-docker 2> /dev/null
cat <<EOF > ./ubuntu-docker/Dockerfile
FROM ubuntu:latest
RUN apt-get update && apt-get install -y python3
EOF

docker build ./ubuntu-docker --file ./ubuntu-docker/Dockerfile --tag ubuntu-py:latest
rm -fr ./ubuntu-docker

docker run -d --name=centos7 --rm centos:centos7 tail -f
docker run -d --name=ubuntu --rm ubuntu-py:latest tail -f
docker run -d --name=fedora --rm pycontribs/fedora:latest tail -f

ansible-playbook site.yml -i inventory/prod.yml --vault-password-file ./vault_pass.txt

docker stop centos7 ubuntu fedora

cd -