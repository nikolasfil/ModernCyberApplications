#!/bin/bash
sudo cat ../files/interfaces > /etc/network/interfaces;
sudo cat ../files/static_dns > /etc/network/interfaces.d/static_dns;
