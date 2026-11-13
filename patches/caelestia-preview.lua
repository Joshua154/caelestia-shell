hl.monitor({ output = "", mode = "1280x720@60", position = "auto", scale = 1 })
hl.on("hyprland.start", function()
    hl.exec_cmd("nix develop -c quickshell -p /home/joshua/Documents/Coding/caelestia-shell/shell.qml")
end)
