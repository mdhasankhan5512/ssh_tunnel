m = Map("custom_ssh_tunnel", "Custom SSH Tunnel Configuration",
    "Modify SSH Tunnel settings.")

s = m:section(NamedSection, "settings", "tunnel", "Tunnel Settings")

-- Server Configuration
servers = s:option(DynamicList, "servers", "Servers",
    "List of servers in the format host:port@username:password:expiry_date (DD-MM-YYYY)")
servers.default = {
    "host1:port1@username1:password1:31-12-2023",
    "host2:port2@username2:password2:15-11-2023",
    "host3:port3@username3:password3:01-01-2024"
}

-- Current Server Information
current_server = s:option(Value, "current_server", "Current Server")
current_server.default = "host1:port1@username1:password1:31-12-2023"
current_server.readonly = true

-- SNI (Server Name Indication)
sni = s:option(Value, "sni", "SNI (Server Name)")
sni.default = "cdn.snapchat.com"

-- Local Proxy Port
local_port = s:option(Value, "local_port", "Local Proxy Port")
local_port.default = "8080"

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
