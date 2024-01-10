#!/bin/bash

# sudo cat ../files/named.conf.option > /etc/bind/named.conf.options;
sudo cat ../files/named.conf.option > /etc/bind/named.conf.options;
sudo cat ../files/named.conf.local.internal > /etc/bind/named.conf.local;

sudo cat ../files/example.db.internal > /var/cache/bind/example.com.db;
sudo cat ../files/192.168.0 > /var/cache/bind/192.168.0;
sudo cat ../files/192.168.122 > /var/cache/bind/192.168.122;


sudo systemctl restart bind9;
sudo systemctl status bind9;

# -------

