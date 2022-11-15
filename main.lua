io.stdout:setvbuf("no")

local lg = love.graphics
lg.setDefaultFilter("nearest")

local g3d = require "g3d"
local Player = require "player"
local vectors = require "g3d/vectors"
local object_designs = require "object_designs"

local player
local objects = {
    ["create_on_load"] = {},
    ["create_on_draw"] = {}
}
local canvas
local accumulator = 0
local frametime = 1/60
local rollingAverage = {}

function love.load()
    lg.setBackgroundColor(0.25,0.5,1)

    player = Player:new(0,0,0)

    for object, info in pairs(require("assets/map_test")) do
        if info[1] ~= nil then
            objects["create_on_draw"][object] = info
        else 
            objects["create_on_load"][object] = g3d.newModel(info[2], info[3], info[4], info[5], info[6], info[7])

            if info[7] == true then
                player:addCollisionModel(objects["create_on_load"][object])
            end
        end
    end

    local width, height = love.window.getMode()
    canvas = {lg.newCanvas(width,height), depth=true}
end

function love.update(dt)
    -- rolling average so that abrupt changes in dt
    -- do not affect gameplay
    -- the math works out (div by 60, then mult by 60)
    -- so that this is equivalent to just adding dt, only smoother
    table.insert(rollingAverage, dt)
    if #rollingAverage > 60 then
        table.remove(rollingAverage, 1)
    end
    local avg = 0
    for i,v in ipairs(rollingAverage) do
        avg = avg + v
    end

    -- fixed timestep accumulator
    accumulator = accumulator + avg/#rollingAverage
    while accumulator > frametime do
        accumulator = accumulator - frametime
        player:update(dt)
    end

    -- interpolate player between frames
    -- to stop camera jitter when fps and timestep do not match
    player:interpolate(accumulator/frametime)
    objects["create_on_load"]["background"]:setTranslation(g3d.camera.position[1],g3d.camera.position[2],g3d.camera.position[3])
end

function love.keypressed(k)
    if k == "escape" then love.event.push("quit") end
end

function love.mousemoved(x,y, dx,dy)
    g3d.camera.firstPersonLook(dx,dy)
end

function love.draw()
    lg.setCanvas(canvas)
    lg.clear(0,0,0,0)

    --lg.setDepthMode("lequal", true)

    for name, object in pairs(objects["create_on_load"]) do
        object:draw()
    end

    for name, objectInfo in pairs(objects["create_on_draw"]) do
        object_designs[objectInfo[1]](objectInfo[4][1], objectInfo[4][2], objectInfo[4][3])
    end

    lg.setColor(1,1,1)

    lg.setCanvas()

    local width, height = love.window.getMode()
    lg.draw(canvas[1], width/2, height/2, 0, 1,-1, width/2, height/2)
    --lg.print(collectgarbage("count"))
end
