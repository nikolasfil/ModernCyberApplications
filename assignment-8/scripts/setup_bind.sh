#!/bin/bash

sudo cat ../files/named.conf.option > /etc/bind/named.conf.options;
sudo cat ../files/example.db > /var/cache/bind/example.com.db;
sudo cat ../files/192.168.0 > /var/cache/bind/192.168.0;

sudo systemctl restart bind9;
sudo systemctl status bind9;

# -------

sudo cat ../files/interfaces > /etc/network/interfaces;
sudo cat ../files/static_dns > /etc/network/interfaces.d/static_dns;
