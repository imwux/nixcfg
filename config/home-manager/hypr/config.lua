function mod(key)
    return mod_key .. " + " .. key
end

-- Autostart
hl.on("hyprland.start", function()
    for command in ipairs(autostart_commands) do
        hl.exec_cmd(command)
    end
end)

-- Fullscreen binds
hl.bind(mod("F"), hl.dsp.window.fullscreen_state({ internal = -1, client = 2 }))
hl.bind(mod("SHIFT + F"), hl.dsp.window.fullscreen_state({ internal = 2, client = 2 }))

-- Window binds
hl.bind(mod("SHIFT + Q"), hl.dsp.window.kill())
hl.bind(mod("TAB"), hl.dsp.workspace.toggle_special())
hl.bind(mod("SHIFT + TAB"), hl.dsp.window.move({ workspace = "special" }))
hl.bind(mod("SPACE"), hl.dsp.window.float({ action = "toggle" }))

hl.bind(mod("Left"), hl.dsp.window.move({ direction = "l" }))
hl.bind(mod("Right"), hl.dsp.window.move({ direction = "r" }))
hl.bind(mod("Up"), hl.dsp.window.move({ direction = "u" }))
hl.bind(mod("Down"), hl.dsp.window.move({ direction = "d" }))

-- Workspace binds
for i = 0, 9 do
    hl.bind(mod(i), hl.dsp.focus({ workspace = i == 0 and 10 or i }))
    hl.bind(mod("SHIFT + " .. i), hl.dsp.window.move({ workspace = i == 0 and 10 or i }))
    hl.bind(mod("SHIFT + ALT + " .. i), hl.dsp.window.move({ workspace = i == 0 and 10 or i, silent = true }))
end

-- Mouse binds
hl.bind(mod("mouse:272"), hl.dsp.window.drag(), { mouse = true })
hl.bind(mod("mouse:273"), hl.dsp.window.resize(), { mouse = true })

-- Command binds
hl.bind(mod("RETURN"), hl.dsp.exec_cmd(commands.new_terminal))
hl.bind(mod("D"), hl.dsp.exec_cmd(commands.run))
hl.bind(mod("SHIFT + S"), hl.dsp.exec_cmd(commands.screenshot))
hl.bind(mod("L"), hl.dsp.exec_cmd(commands.lockscreen))
hl.bind(mod("V"), hl.dsp.exec_cmd(commands.clipboardhistory))

-- Media binds
hl.bind("XF86AudioPrev", hl.dsp.exec_cmd(commands.media.previous), { locked = true })
hl.bind("XF86AudioNext", hl.dsp.exec_cmd(commands.media.next), { locked = true })
hl.bind("XF86AudioPlay", hl.dsp.exec_cmd(commands.media.play_pause), { locked = true })

-- Audio binds
hl.bind("XF86AudioRaiseVolume", hl.dsp.exec_cmd(commands.audio.raise_volume), { locked = true, repeating = true })
hl.bind("XF86AudioLowerVolume", hl.dsp.exec_cmd(commands.audio.lower_volume), { locked = true, repeating = true })
hl.bind("XF86AudioMicMute", hl.dsp.exec_cmd(commands.audio.toggle_mic_mute), { locked = true })
hl.bind("XF86AudioMute", hl.dsp.exec_cmd(commands.audio.toggle_mute), { locked = true })

-- Brightness binds
hl.bind("XF86MonBrightnessUp", hl.dsp.exec_cmd(commands.brightness.up), { locked = true, repeating = true })
hl.bind("XF86MonBrightnessDown", hl.dsp.exec_cmd(commands.brightness.down), { locked = true, repeating = true })
