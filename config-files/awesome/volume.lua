volume_widget = widget({ type = "textbox", name = "tb_volume",
    align = "right" })

function update_volume(widget)
    local fd = io.popen("amixer sget Master")
    local status = fd:read("*all")
    fd:close()
    
    local volume = tonumber(string.match(status, "(%d?%d?%d)%%")) / 100

    status = string.match(status, "%[(o[^%]]*)%]")

   if string.find(status, "on", 1, true) then
       -- For the volume numbers
       volume = '  [<span color="#00FF00">' .."Volume: "..volume.. ' ♫</span>]  '
   else
       -- For the mute button
       volume = '  [<span color="#FF0000">Muted</span>]  '
       
   end

    widget.text = volume
 end

update_volume(volume_widget)
awful.hooks.timer.register(1, function () update_volume(volume_widget) end)
