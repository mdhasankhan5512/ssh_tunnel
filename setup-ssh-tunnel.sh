#!/bin/sh
opkg update
opkg install tmux sshpass autossh openssh-client openssl-util
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh_tunnel/refs/heads/main/zzz
mv zzz /etc/init.d/
chmod +x /etc/init.d/zzz
service zzz enable
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh_tunnel/refs/heads/main/tunnel.sh
mv tunnel.sh /root/
chmod +x /root/tunnel.sh
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh_tunnel/refs/heads/main/custom_ssh_tunnel.lua
mv custom_ssh_tunnel.lua /usr/lib/lua/luci/model/cbi/
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh_tunnel/refs/heads/main/controllar.lua
mv controllar.lua /usr/lib/lua/luci/controller/custom_ssh_tunnel.lua
cat <<EOF > /etc/config/custom_ssh_tunnel
config tunnel 'settings'
    option current_server '139.59.235.231:443@racevpn.com-alyan36:H5512552:24-02-2025'
    option sni 'cdn.snapchat.com'
    option local_port '8080'
    list servers '139.59.235.231:443@racevpn.com-alyan36:H5512552:24-02-2025'
    list servers 'sg4.tun1.pro:443@sshstores-shayan34:H5512552:26-02-2025'
EOF
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh_tunnel/refs/heads/main/zzzz
mv zzzz /etc/init.d/
chmod +x /etc/init.d/zzzz
service zzzz enable
wget https://raw.githubusercontent.com/mdhasankhan5512/ssh_tunnel/refs/heads/main/check.py
/etc/init.d/rpcd restart
