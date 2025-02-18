m = Map("custom_ssh_tunnel", "Custom SSH Tunnel Configuration",
    "Modify SSH Tunnel settings.")

s = m:section(NamedSection, "settings", "tunnel", "Tunnel Settings")

-- SSH Host
host = s:option(Value, "host", "SSH Host")
host.default = "206.189.80.210"

-- SSH Port
port = s:option(Value, "port", "SSH Port")
port.default = "443"

-- SSH Username
username = s:option(Value, "username", "SSH Username")
username.default = "racevpn.com-alyan26"

-- SSH Password
password = s:option(Value, "password", "SSH Password")
password.password = true
password.default = "H5512552"

-- SNI (Server Name Indication)
sni = s:option(Value, "sni", "SNI (Server Name)")
sni.default = "cdn.snapchat.com"

-- Local Proxy Port
local_port = s:option(Value, "local_port", "Local Proxy Port")
local_port.default = "8080"

-- Expiration Date
expire = s:option(Value, "expire", "Expire Date")
expire.placeholder = "DD-MM-YYYY"
expire.datatype = "string"

-- SSH Tunnel Status
status = s:option(DummyValue, "_status", "SSH Tunnel Status")
status.rawhtml = true
function status.cfgvalue(self, section)
    local cursor = luci.model.uci.cursor()
    local port = cursor:get("custom_ssh_tunnel", "settings", "local_port") or "8080"
    local check = io.popen("netstat -tulnp | grep ':" .. port .. "'")
    local result = check:read("*all")
    check:close()
    
    if result and result ~= "" then
        return "<b><span style='color: green;'>Running</span></b>"
    else
        return "<b><span style='color: red;'>Stopped</span></b>"
    end
end

-- Start SSH Tunnel Service Button
start_btn = s:option(Button, "_start", "Start SSH Tunnel")
start_btn.inputtitle = "Start"
start_btn.inputstyle = "apply"
function start_btn.write(self, section)
    os.execute("service zzz start &")
end

-- Stop SSH Tunnel Service Button
stop_btn = s:option(Button, "_stop", "Stop SSH Tunnel")
stop_btn.inputtitle = "Stop"
stop_btn.inputstyle = "reset"
function stop_btn.write(self, section)
    os.execute("service zzz stop &")
end

return m
