#!/bin/bash
/usr/sbin/iptables -t filter --flush
/usr/sbin/iptables -P INPUT DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p tcp -m quota --quota 60 -j DROP

/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 100 -j ACCEPT
/usr/sbin/iptables -A INPUT -p udp -m quota --quota 60 -j DROP

