vagrant-ubuntu-docker-shell-provision-example
=============================================

An example Vagrant file for building and running multiple docker containers
on Ubuntu 14.04 using the Vagrant shell provisioner.

# How to run

## Set up Ubuntu 14.04 box

I used the packer template for ubuntu-14.04 in
[shiguredo/packer-templates](https://github.com/shiguredo/packer-templates).

## Start vagrant

```
PRIVATE_IP=192.168.33.100 vagrant up
```

or just

```
vagrant up
```

PRIVATE_IP default value 192.168.33.13 is used.
