#!/bin/sh
opkg update
opkg install tmux sshpass autossh openssh-client openssl-util python3
rm /etc/init.d/zzz
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/zzz
mv zzz /etc/init.d/
chmod +x /etc/init.d/zzz
service zzz enable
rm /root/tunnel.sh
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/tunnel.sh
mv tunnel.sh /root/
chmod +x /root/tunnel.sh
rm /usr/lib/lua/luci/model/cbi/custom_ssh_tunnel.lua
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/custom_ssh_tunnel.lua
mv custom_ssh_tunnel.lua /usr/lib/lua/luci/model/cbi/
rm /usr/lib/lua/luci/controller/custom_ssh_tunnel.lua
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/controllar.lua
mv controllar.lua /usr/lib/lua/luci/controller/custom_ssh_tunnel.lua
rm /etc/config/custom_ssh_tunnel
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/conf
mv conf /etc/config/custom_ssh_tunnel
rm /etc/init.d/zzzz
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/zzzz
mv zzzz /etc/init.d/
chmod +x /etc/init.d/zzzz
service zzzz enable
rm check.py
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/check.py
/etc/init.d/rpcd restart
