-- TODO – show sliders for variables
-- TODO – read about this model

local UI = require "UI"
local size = 5
local dir = { 
    {0,1}, {0,-1}, {1,0}, {-1,0}, 
    {1,1}, {-1,1}, {-1,-1}, {1,-1} 
}


function initGrid ( grid )
    grid.canvas = love.graphics.newCanvas( 
        grid.width * size, 
        grid.height * size 
    )

    for i = 0, grid.height-1 do
        grid[i] = {}
        for j = 0, grid.width-1 do
            local init = love.math.random()
            if init <= rabbit_init[1] then
                grid[i][j] = "rabbit"
            elseif init <= rabbit_init[1] + fox_init[1] then
                grid[i][j] = "fox"
            else
                grid[i][j] = ""
            end
        end
    end
end

function updateGrid ( grid )
    for i = 0, grid.height-1 do
        for j = 0, grid.width-1 do
            local tile = grid[i][j]
            if tile == "fox" then
                processFox( grid, j, i )
            elseif tile == "rabbit" then
                processRabbit( grid, j, i )
            end
        end
    end
end

function randomInt ( min, max )
    return math.floor( love.math.random() * ( max - min + 1 ) ) + min
end

function processRabbit ( grid, x, y )
    if love.math.random() <= rabbit_birth[1] then
        setRandomEmpty( grid, x, y, "rabbit" )
    end
    grid[y][x] = ""
    setRandomEmpty( grid, x, y, "rabbit" )
end

function processFox ( grid, x, y )
    local starving = true
    for _,v in ipairs( dir ) do
        _x = (x + v[2]) % grid.width
        _y = (y + v[1]) % grid.height
        if grid[_y][_x] == "rabbit" then
            starving = false
            grid[_y][_x] = ""
            if love.math.random() <= fox_birth[1] then
                grid[_y][_x] = "fox"
            end
        end
    end

    if starving and love.math.random() <= fox_death[1] then
        grid[y][x] = ""
    else
        grid[y][x] = ""
        setRandomEmpty( grid, x, y, "fox" )
    end
end

function setRandomNeighbour ( grid, x, y, type )
    local rand = randomInt( 1, 4 )
    _x = (x + dir[rand][2]) % grid.width
    _y = (y + dir[rand][1]) % grid.height
    grid[_y][_x] = type
end

function setRandomEmpty ( grid, x, y, type )
    local empty = {}
    for _,v in ipairs( dir ) do
        _x = (x + v[2]) % grid.width
        _y = (y + v[1]) % grid.height
        if grid[_y][_x] == "" then
            table.insert( empty, {_y,_x} )
        end
    end
    if #empty > 0 then
        local rand = randomInt( 1, #empty )
        grid[empty[rand][1]][empty[rand][2]] = type
    else
        grid[y][x] = type
    end
end

function isNeighbour ( grid, x, y, type )
    for _,v in ipairs( dir ) do
        _x = (x + v[2]) % grid.width
        _y = (y + v[1]) % grid.height
        if grid[_y][_x] == type then
            return true
        end
    end
    return false
end


function love.load ()

    speed = { 10 }
    rabbit_init = { 0.1 }
    fox_init = { 0.05 }
    fox_death = { 0.05 }
    fox_birth = { 0.1 }
    rabbit_birth = { 0.03 }

    grid = {
        width = 100,
        height = 100,
    }

    initGrid( grid )

    function startSimulation()
        initGrid( grid )
        pause = false
    end
    function pauseSimulation()
        pause = true
    end

    love.graphics.setBackgroundColor( 1, 1, 1 )

    UI:addScene( 20, 20 )
    UI:horizontal(
        UI:addButton( "Start", startSimulation ),
        UI:addButton( "Pause", pauseSimulation )
    )
    UI:vertical(
        UI:addLabel {""},
        UI:addLabel {"Speed: "},
        UI:addSlider( 1, 60, speed ),
        UI:addLabel {"Initial percentage of rabbits: "},
        UI:addSlider( 0, 0.5, rabbit_init ),
        UI:addLabel {"Initial percentage of foxes: "},
        UI:addSlider( 0, 0.5, fox_init ),
        UI:addLabel {"Chance of starving fox death: "},
        UI:addSlider( 0, 0.3, fox_death ),
        UI:addLabel {"Chance of fox birth: "},
        UI:addSlider( 0, 0.3, fox_birth ),
        UI:addLabel {"Chance of rabbit birth: "},
        UI:addSlider( 0, 0.3, rabbit_birth )
    )

    timer = 0
end


function love.update ( dt )

    timer = timer + dt
    if timer > (1 / speed[1]) then
        timer = timer - (1 / speed[1])
        if not pause then
            updateGrid( grid )
        end
    end

end

function love.draw ()

    local r,g,b,a = love.graphics.getColor()

    love.graphics.setCanvas( grid.canvas )
    drawGrid( grid )
    love.graphics.setCanvas()

    local margin = 100
    love.graphics.draw( 
        grid.canvas, 
        love.graphics.getWidth() - grid.canvas:getWidth() - margin,
        margin
        )
    
    UI:draw()
end

function drawGrid ()
    local r,g,b,a = love.graphics.getColor()
    local width = #grid[1]
    local height = #grid
    local ts = size

    for i = 0, height-1 do
        for j = 0, width-1 do
            local color
            if grid[i][j] == "" then
                color = { 1, 1, 1 }
            elseif grid[i][j] == "rabbit" then
                color = { 0, 1, 0 }
            elseif grid[i][j] == "fox" then
                color = { 1, 0, 0 }
            end

            love.graphics.setColor( color )
            love.graphics.rectangle( "fill", (j-1) * ts, (i-1) * ts, ts, ts )
        end
    end
    love.graphics.setColor( r,g,b,a )
end


function love.keypressed ( key )
    if key == "escape" then
        love.event.quit()
    end
end

function love.mousepressed ( x, y, button )
    if button == 1 then
        UI:mousePressed({x = x, y = y})
    end
end

function love.mousereleased ( x, y, button )
    if button == 1 then
        UI:mouseReleased({x = x, y = y})
    end
end

function love.mousemoved ( x, y )
    UI:mouseMoved({x = x, y = y})
end
