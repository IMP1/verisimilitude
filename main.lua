local entity_manager = require 'ecs.entity_manager'
local system_manager = require 'ecs.system_manager'

local input            = require 'lib.input'

local keyboard_handler = require 'input.devices.handler_keyboard'
local mouse_handler    = require 'input.devices.handler_mouse'


local FRAMES_PER_SECOND = 60
local SECONDS_PER_FRAME = 1 / FRAMES_PER_SECOND

local delta_time = 0

function love.load()
    math.randomseed(os.time())
    math.random(); math.random(); math.random()
    love.graphics.setDefaultFilter("nearest", "nearest")

    system_manager.bind(entity_manager)
    system_manager.hook()

    -- system_manager.load_system("systems/debugger.lua", true)
    -- entity_manager.load_entity("entities/map.lua")
    
    keyboard_handler.load()
    mouse_handler.load()

    local scheme_1 = require 'input.input_schemes.keyboardmouse_gameplay'
    input.add_input_scheme(scheme_1)

end

function love.update(dt)
    delta_time = delta_time + dt
    if delta_time >= SECONDS_PER_FRAME then
        delta_time = delta_time - SECONDS_PER_FRAME

        system_manager.update(SECONDS_PER_FRAME)
    end
end

function love.draw()
    system_manager.draw()
end