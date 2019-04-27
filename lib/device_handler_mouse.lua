local device_handler = {}

local KEY_NAMES = {
    ["0"] = "mouse position",
    ["1"] = "left button",
    ["2"] = "right button",
    ["3"] = "middle button",
    ["4"] = "wheel",
}

local KEY_TYPES = {
    ["0"] = "axis2D",
    ["1"] = "button",
    ["2"] = "button",
    ["3"] = "button",
    ["4"] = "axis1D",
}

local device_name = "mouse"
local device_id   = nil

local function get_device_info()
    return {
        id   = device_id,
        name = device_name,
    }
end

function device_handler.get_state(device_id, key)

    local devicename = "mouse"
    local keyname    = KEY_NAMES[key]
    local keytype    = KEY_TYPES[key]
    local properties = {}

    if key == "0" then
        properties.x = love.mouse.getX()
        properties.y = love.mouse.getY()
    elseif key == "1" then
        properties.is_pressed = love.mouse.isDown(1)
    elseif key == "2" then
        properties.is_pressed = love.mouse.isDown(2)
    elseif key == "3" then
        properties.is_pressed = love.mouse.isDown(3)
    elseif key == "4" then
        properties.x = 0
    end

    return {
        devicename = devicename,
        keyname    = keyname,
        keytype    = keytype,
        state      = properties,
    }
end


function device_handler.load()
    device_id = input.register_device(device_handler)

    input.subscribe("mousemoved", function(x, y, dx, dy, istouch)
        local key = "0"
        local device_info = get_device_info()
        local event_info = {
            keyname = KEY_NAMES[key],
            keytype = KEY_TYPES[key],
            key     = key,
            action  = "move",
        }
        input.handle_device_event(device_info, event_info, dx, dy)
    end)

    input.subscribe("mousepressed", function(x, y, button, istouch, presses)
        local key = tostring(button)
        local device_info = get_device_info()
        local event_info = {
            keyname = KEY_NAMES[key] or key,
            keytype = KEY_TYPES[key],
            key     = key,
            action  = "press",
        }
        input.handle_device_event(device_info, event_info)
    end)

    input.subscribe("mousereleased", function(x, y, button, istouch, presses)
        local key = tostring(button)
        local device_info = get_device_info()
        local event_info = {
            keyname = KEY_NAMES[key] or key,
            keytype = KEY_TYPES[key],
            key     = key,
            action  = "release",
        }
        input.handle_device_event(device_info, event_info)
    end)

    input.subscribe("wheelmoved", function(x, y)
        local key = "4"
        local device_info = get_device_info()
        local event_info = {
            keyname = KEY_NAMES[key] or key,
            keytype = KEY_TYPES[key],
            key     = key,
            action  = "move",
        }
        input.handle_device_event(device_info, event_info, -y)
    end)
end

return device_handler