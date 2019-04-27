local input = require 'lib.input'

local device_handler = {}

local KEY_NAMES = {
    [" "] = "space",
}

local device_name = "keyboard"
local device_id   = nil

local function get_device_info()
    return {
        id   = device_id,
        name = device_name,
    }
end

function device_handler.get_state(device_id, key)

    local devicename = "keyboard"
    local keyname    = KEY_NAMES[key] or key
    local keytype    = "button"
    local properties = {}

    properties.is_pressed = love.keyboard.isDown(keyname)

    return {
        devicename = devicename,
        keyname    = keyname,
        keytype    = keytype,
        state      = properties,
    }
end

function device_handler.load()
    device_id = input.register_device(device_handler)

    input.subscribe("keypressed", function(key, scancode, isrepeat)
        local device_info = get_device_info()
        local event_info = {
            keyname = KEY_NAMES[key] or key,
            keytype = "button",
            key     = key,
            action  = "press",
        }
        input.handle_device_event(device_info, event_info)
    end)

    input.subscribe("keyreleased", function(key, scancode)
        local device_info = get_device_info()
        local event_info = {
            keyname = KEY_NAMES[key] or key,
            keytype = "button",
            key     = key,
            action  = "release",
        }
        input.handle_device_event(device_info, event_info)
    end)

    input.subscribe("textedited", function(text, start, length)

    end)

    input.subscribe("textinput", function(text)

    end)
end


return device_handler