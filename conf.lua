-------------------
-- CONFIG FILE
-------------------

function love.conf ( t )
    t.modules.physics = false
    t.modules.joystick = false
    t.window.title = "Lotka-Volterra simulation"
    t.window.fullscreen = false
    t.window.resizable = true
    t.window.vsync = 1

end
