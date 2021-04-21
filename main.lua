
worldMap = {
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,1,1,1,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,1,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,1,1,1,1,0,1,1,1,1,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,0,0,0,0,0,0,0,0,1,0,0,0,0,0,0,0,0,0,1},
    {1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1,1}
}

local posX=12
local posY=5
local dirX=-1
local dirY=0
local planeX=0
local planeY=.66

local maxDist=0

local buffer = {}
local texture = {}

local moveSpeed,rotSpeed

function love.load()
end

function love.update(dt)
    moveSpeed = dt * 5
    rotSpeed = dt * 2
    if love.keyboard.isDown("escape") then
        os.exit()
    end
    if love.keyboard.isDown("up") then
        if worldMap[math.floor(posX + dirX * moveSpeed)][math.floor(posY)] == 0 then 
            posX = posX + dirX * moveSpeed 
        end
        if worldMap[math.floor(posX)][math.floor(posY + dirY * moveSpeed)] == 0 then 
            posY = posY + dirY * moveSpeed 
        end
    end

    if love.keyboard.isDown("down") then
        if worldMap[math.floor(posX - dirX * moveSpeed)][math.floor(posY)] == 0 then 
            posX = posX - dirX * moveSpeed 
        end
        if worldMap[math.floor(posX)][math.floor(posY - dirY * moveSpeed)] == 0 then 
            posY = posY - dirY * moveSpeed 
        end
    end

    if love.keyboard.isDown("right") then
        local oldDirX = dirX
        dirX = dirX * math.cos(-rotSpeed) - dirY * math.sin(-rotSpeed)
        dirY = oldDirX * math.sin(-rotSpeed) + dirY * math.cos(-rotSpeed)

        local oldPlaneX = planeX
        planeX = planeX * math.cos(-rotSpeed) - planeY * math.sin(-rotSpeed)
        planeY = oldPlaneX * math.sin(-rotSpeed) + planeY * math.cos(-rotSpeed)
    end

    if love.keyboard.isDown("left") then
        local oldDirX = dirX
        dirX = dirX * math.cos(rotSpeed) - dirY * math.sin(rotSpeed)
        dirY = oldDirX * math.sin(rotSpeed) + dirY * math.cos(rotSpeed)

        local oldPlaneX = planeX
        planeX = planeX * math.cos(rotSpeed) - planeY * math.sin(rotSpeed)
        planeY = oldPlaneX * math.sin(rotSpeed) + planeY * math.cos(rotSpeed)
    end
end

function love.draw()
    WIDTH = love.graphics.getWidth()
    HEIGHT = love.graphics.getHeight()
    love.graphics.setColor(1, 1, 1)
    love.graphics.print("w: "..WIDTH.." h:"..HEIGHT, 0, 0)
    love.graphics.print("pos ("..math.floor(posX)..", "..math.floor(posY)..")", 0, 12)
    love.graphics.print("dir ("..math.ceil(dirX)..", "..math.ceil(dirY)..")", 0, 24)
    
    love.graphics.setColor(0.2,0.2,0.2)
    love.graphics.rectangle("fill", 0, 0, WIDTH, HEIGHT / 2)
    for x=0,WIDTH do

        local cameraX = 2 * x / WIDTH - 1
        local rayDirX = dirX + planeX * cameraX
        local rayDirY = dirY + planeY * cameraX
        local rayPosX = posX
        local rayPosY = posY

        local sideDistX 
        local sideDistY

        local mapX = math.floor(rayPosX)
        local mapY = math.floor(rayPosY)

        local deltaDistX = math.sqrt( 1 + (rayDirY * rayDirY) / (rayDirX * rayDirX))
        local deltaDistY = math.sqrt( 1 + (rayDirX * rayDirX) / (rayDirY * rayDirY))
        local wallDist

        local stepX, stepY
        local hit = 0
        local side

        if rayDirX < 0 then
            stepX = -1
            sideDistX = (rayPosX - mapX) * deltaDistX
        else
            stepX = 1
            sideDistX = (mapX + 1 - rayPosX) * deltaDistX
        end

        if rayDirY < 0 then
            stepY = -1
            sideDistY = (rayPosY - mapY) * deltaDistY
        else
            stepY = 1
            sideDistY = (mapY + 1 - rayPosY) * deltaDistY
        end

        while hit == 0 do
            if sideDistX < sideDistY then
                sideDistX = sideDistX + deltaDistX
                mapX = mapX + stepX
                side = 0
            else
                sideDistY = sideDistY + deltaDistY
                mapY = mapY + stepY
                side = 1
            end

            if worldMap[mapX][mapY] > 0 then hit = 1 end 
        end

        if side == 0 then wallDist = (mapX - rayPosX + ( 1 - stepX) / 2) / rayDirX
        else wallDist = (mapY - rayPosY + ( 1 - stepY) / 2) / rayDirY end
        
        local r = wallDist / 30.0
        local g = wallDist / 30.0
        local b = wallDist / 30.0

        lineHeight = HEIGHT / wallDist

        drawStart = -lineHeight / 2 + HEIGHT / 2
        if drawStart < 0 then drawStart = 0 end
        drawEnd = lineHeight / 2 + HEIGHT / 2
        if drawEnd >= HEIGHT then drawEnd = HEIGHT - 1 end

        if worldMap[mapX][mapY] == 1 then
            love.graphics.setColor(1-r, 1-g, 1-b)
        end

        if side == 1 then
            love.graphics.setColor(0.5-(r/2),0.5-(g/2),0.5-(b/2))
        end

        love.graphics.line(x, drawStart, x, drawEnd)

    end
end