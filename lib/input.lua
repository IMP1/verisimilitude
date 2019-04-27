local input = {
    _VERSION     = 'v0.1.0',
    _DESCRIPTION = [[
An input library for LÖVE, made to work similarly to Unity's InputSystem. 
Devices are managed separately to provide standardised input events and states.

    ]],
    _URL         = '',
    _LICENSE     = [[
        MIT License

        Copyright (c) 2017 Huw Taylor

        Permission is hereby granted, free of charge, to any person obtaining a copy
        of this software and associated documentation files (the "Software"), to deal
        in the Software without restriction, including without limitation the rights
        to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
        copies of the Software, and to permit persons to whom the Software is
        furnished to do so, subject to the following conditions:

        The above copyright notice and this permission notice shall be included in all
        copies or substantial portions of the Software.

        THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
        IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
        FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
        AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
        LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
        OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
        SOFTWARE.
    ]],
}

--[[ Vocabulary

Key: 
A property of an input device. The space bar is a key of the keyboard device, 
and the mouse wheel is a key of the mouse device, but the mouse's position is
also a key of the mouse device.
There are a few types of key types: 
  * button, which is a traditional on/off switch, like a key on a keyboard, or 
    a button on a mouse or gamepad; 
  * axis1D, which is a value that can altered in one of two directions, like a 
    scroll wheel, or a single direction of a joystick; 
  * axis2D, which is a pair of values that can be altered in one of two 
    directions in two different dimensions, like a gamepad's joystick, or the 
    mouse's position;

State: 
An ongoing property of a device's key.
  * button: is_pressed,
  * axis1D: x,
  * axis2D: x, y,

Device: 
A physical means of obtaining user input. A mouse, a keyboard, a gamepade.

DeviceManager: 
A translator from button presses to standardised virtual inputs, converting from
different types of gamepads, for example.
DeviceManager need to have the following properties:
  * get_state(key_id) -> state
  * 

Device Event: 
A "physical" input from the player. A press of a button on a gamepad.

Virtual Event: 
A standardised event format, in terms of keys and referencing devices, that can 
be passed to schemes to be translated into game events.

Game Event: 
A context-dependent event that is relevent to the gameplay. For example, 
pressing space would be a device event and a virtual event, but could, in 
certain contexts and schems, translate to a 'jump' game event.

Context: 
An environment in which virtual events translate to game events. The 'gameplay' 
context might translate a mouse click into shooting, but the 'menu' context 
would instead translate it into selection of a menu item.

Scheme: 
A collection of mappings from virtual events to game events, within contexts.
Schemes need to have the following properties:
  * uses_device(device_id) -> boolean
  * handle_event(event)

--]]

local next_device_id = 1
local device_managers = {}

local input_mapping_schemes = {}

local current_context = nil

function input.register_device(device_manager)
    local id = next_device_id
    device_managers[id] = device_manager
    next_device_id = next_device_id + 1
    return id
end

function input.subscribe(love_event_name, func)
    local old_func = love.handlers[love_event_name]
    love.handlers[love_event_name] = function(...)
        old_func(...)
        func(...)
    end
end

function input.add_input_scheme(scheme)
    table.insert(input_mapping_schemes, scheme)
end

function input.set_context(new_context)
    current_context = new_context
end

-- To be used by Device Managers only, push standardised virtual input events.
function input.handle_device_event(device, event, ...)
    local event = {
        device     = device.id,
        devicename = device.name,
        keyname    = event.keyname,
        keytype    = event.keytype,
        key        = event.key,
        action     = event.action,
        params     = {...},
    }
    for _, scheme in pairs(input_mapping_schemes) do
        if scheme.uses_device(device.id) then
            scheme.handle_event(event)
        end
    end
end

function input.get_device_state(device_id, key)
    local device_manager = device_managers[device_id]
    local state = device_manager.get_state(device_id, key)

    return {
        device     = device_id,
        devicename = state.devicename,
        keyname    = state.keyname,
        keytype    = state.keytype,
        key        = key,
        state      = state.properties,
    }
end

function input.get_state(device_id, state_name)
    -- @TODO: use the current context to translate the state_name to a key_id
    --        maybe pass the context and key_id to the device manager? Or the scheme?

end

--[[ Ideas


controllable characters will have a component marking them as controllable.
this component will reference an input mapping scheme.
this input mapping will be what?
binding -> action
binding can be one of the following:
  * a button press (mouse click, keyboard press, gamepad button press)
  * a 1D axis (mouse scrolling)
  * a 2D axis (WASD, gamepad D-Pad, gamepad joystick, mouse movement)
an action fires a named event with a table containing the following info:
  * 
  * 
  * 
binding -> state
  * is button down (mouse pressed, keypressed, gamepad buttom pressed)
  * is combination of buttons down (buttons are flags/values, return total of flags)
    eg. w = (0, -1), a = (-1, 0), s = (0, 1), d = (1, 0) - returns total

physical inputs

 1. mouse pressed left button
 2. mouse moved
 3. gamepad right axis moved up
 4. keyboard pressed 'P'
 5. keyboard released ' '

-> standardised virtual input

 1. { device=1, devicename="mouse",     keyname="left button", key="1", action="press",   params={} }
 2. { device=1, devicename="mouse",     keyname="position",    key="0", action="move",    params={dx, dy} }
 3. { device=3, devicename="gamepad_1", keyname="right axis",  key="9", action="move",    params={dx, dy} }
 4. { device=2, devicename="keyboard",  keyname="p",           key="p", action="press",   params={} }
 5. { device=2, devicename="keyboard",  keyname="space",       key=" ", action="release", params={} }

actions:
  * press
  * release
  * move

-> active input mapping schemes (eg. keyboard+mouse FPS gameplay) -> 

 1. shoot
 2. look
 3. look
 4. open inventory
 5. jump

OR active input mapping schemes (eg. keyboard+mouse menu) -> 

 1. select
 2. hover
 3. ---
 4. ---
 5. select


physical states

 1. keyboard pressed?
 2. mouse position

standardised virtual input query

 1. { device=1, key="1" } -> { device=1, key="1", state = {is_pressed=true} }
 2. { device=1, key="0" } -> { device=1, key="0", state = {x=x, y=y} }

states:
  * is_pressed
  * position

--]]

