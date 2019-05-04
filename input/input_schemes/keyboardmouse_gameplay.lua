local mouse_handler    = require 'input.devices.handler_mouse'
local keyboard_handler = require 'input.devices.handler_keyboard'

local scheme = {}

function scheme.uses_device(device_id)
    local mouse_id = mouse_handler.get_info().ids[1]
    local keyboard_id = keyboard_handler.get_info().ids[1]
    return device_id == keyboard_id or device_id == mouse_id
end

function scheme.handle_event(event)
    print("event")
end

return scheme