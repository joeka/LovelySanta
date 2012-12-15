local game = Gamestate.new()

world = nil

require "effects.effects"
require "entities.entities"
require "functions.camerafollow"

local player
local ground = {}
local activeEffects = {}

local camera = nil
local objects= {}

function game:init()
	love.graphics.setBackgroundColor(100, 130, 250)
	
	love.physics.setMeter(64)
	world = love.physics.newWorld( 0, 640, true )

	ground.body = love.physics.newBody(world, 50000, 550)
	ground.shape = love.physics.newRectangleShape(100000, 50)
	ground.fixture = love.physics.newFixture(ground.body, ground.shape)

	player = Player( Vector(300,100))
	camera = Camera(player.pos.x, player.pos.y, 0.7)


end

function game:enter()
	
end

function game:update( dt )
	world:update(dt)
	--update effects
	for _, effect in pairs(activeEffects) do
		effect:update(dt)
	end
	--update objects
	for _,object in pairs(objects) do
		object:update(dt)
	end

	player:update(dt)

	smoothFollow(camera, Vector(player.reindeer.body:getX(), player.reindeer.body:getY()), dt, 16, 400, 4 )


	-- controls
	local velocity = player.reindeer.body:getLinearVelocity()
	local dir = Vector(0,0)
	if love.keyboard.isDown("right") then 
		dir.x = 1
	elseif love.keyboard.isDown("left") then
		dir.x = -1
	end
	if love.keyboard.isDown("up") then
		dir.y = -1
	elseif love.keyboard.isDown("down") then
		dir.y = 1
	end
	local force = Vector(0,0)
	if dir.x ~= 0 and math.abs(velocity) < 250 then
		force.x = dir.x * 150000 * dt
	end
	if dir.y < 0 and velocity > 150 then
		force.y = dir.y * player.yForce * 100 * dt
		player.yForce = player.yForce * (1 - dt*2)
	elseif dir.y > 0 then
		force.y = dir.y * 10000 *dt
		player.yForce = math.min (player.yForce * (1 + dt*2), 10000)
	else
		player.yForce = math.min (player.yForce * (1 + dt*2), 10000)
	end
	if force:len() ~= 0 then
		player.reindeer.body:applyForce(force.x, force.y)
		player.sleigh.body:applyForce(0, force.y/3)
	end
	--print ( velocity, force.x, force.y , player.yForce) 
		
end

function game:draw()
	camera:attach()

	for _, effect in pairs(activeEffects) do
		effect:draw()
	end
	for _, object in pairs(objects) do
		love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
		object:draw()
	end


	love.graphics.polygon("fill", player.sleigh.body:getWorldPoints(player.sleigh.shape:getPoints()))
	love.graphics.polygon("fill", player.reindeer.body:getWorldPoints(player.reindeer.shape:getPoints()))
	player:draw()

	love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

	camera:detach()
end

function game:keypressed( key )
	if key == "escape" then
		Gamestate.switch( states.start )
	end
	if key == "h" then
		table.insert(objects,Human( player.pos + Vector(800, 0) ))
	end
end

return game
