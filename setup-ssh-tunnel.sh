#!/bin/sh
opkg update
opkg install tmux sshpass autossh openssh-client openssl-util python3
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/zzz
rm /etc/init.d/zzz
mv zzz /etc/init.d/
chmod +x /etc/init.d/zzz
service zzz enable
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/tunnel.sh
rm /root/tunnel.sh
mv tunnel.sh /root/
chmod +x /root/tunnel.sh
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/custom_ssh_tunnel.lua
rm /usr/lib/lua/luci/model/cbi/custom_ssh_tunnel.lua
mv custom_ssh_tunnel.lua /usr/lib/lua/luci/model/cbi/
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/controllar.lua
rm /usr/lib/lua/luci/controller/custom_ssh-tunnel.lua
mv controllar.lua /usr/lib/lua/luci/controller/custom_ssh-tunnel.lua
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/conf
rm /etc/config/custom_ssh_tunnel
mv conf /etc/config/custom_ssh_tunnel
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/zzzz
rm /etc/init.d/zzzz
mv zzzz /etc/init.d/
chmod +x /etc/init.d/zzzz
service zzzz enable
rm check.py
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh-tunnel/refs/heads/main/check.py
/etc/init.d/rpcd restart
