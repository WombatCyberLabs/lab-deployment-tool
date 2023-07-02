#!/bin/sh

user=$1
host=$2
key=$3
repo=$4

usage(){
	echo "Usage: ./deploy.sh [user] [host:port] /path/to/key [repo url]"
	exit 1
}

if [ -z "$user" ] || [ -z "$host" ] || [ -z "$key" ] || [ -z "$repo" ]; then
	usage
elif [ -f "$key" ]; then
	echo "[target]\n$host ansible_ssh_private_key_file=$key" > hosts
	cp deploy.yml deploy-instance.yml
	echo "          repo_name: $repo" >> deploy-instance.yml
	ansible-playbook --become -u $user -i hosts deploy-instance.yml
else
	echo "Key $key not found!"
fi
