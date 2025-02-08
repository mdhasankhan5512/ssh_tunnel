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

-- SSH Tunnel Status (Hidden Initially)
status = s:option(DummyValue, "_status", "SSH Tunnel Status")
status.rawhtml = true
status.default = "Click 'Check Status' to refresh"

-- Check Status Button
status_btn = s:option(Button, "_status_check", "Check Status")
status_btn.inputtitle = "Check Status"
status_btn.inputstyle = "apply"

function status_btn.write(self, section)
    local cursor = luci.model.uci.cursor()
    local port = cursor:get("custom_ssh_tunnel", "settings", "local_port") or "8080"
    
    -- Run command in background (&)
    os.execute("service zzz start &")

    -- Check if port is listening
    local check = io.popen("netstat -tulnp | grep ':" .. port .. "'")
    local result = check:read("*all")
    check:close()
    
    if result and result ~= "" then
        status.default = "<b><span style='color: green;'>Running</span></b>"
    else
        status.default = "<b><span style='color: red;'>Stopped</span></b>"
    end
end

return m
