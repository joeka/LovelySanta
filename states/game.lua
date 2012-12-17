local game = Gamestate.new()

world = nil

require "effects.effects"
require "entities.entities"
require "functions.camerafollow"

local gui = require "functions.gui"

local player
local ground = {}
local activeEffects = {}

local camera = nil
local objects= {}

local backImages = {}
local floorImages = {}

local back = {}
local floor = {}

local spawnPosition = nil
local humanLimit = 30

function game:init()
	love.graphics.setBackgroundColor(100, 130, 250)
	
	self:setupBackground()

	love.physics.setMeter(64)
	world = love.physics.newWorld( 0, 640, true )
	world:setCallbacks(beginContact, endContact, preSolve, postSolve)

	ground.body = love.physics.newBody(world, 5000000, 550)
	ground.shape = love.physics.newRectangleShape(10000000, 50)
	ground.fixture = love.physics.newFixture(ground.body, ground.shape)
	ground.fixture:setUserData({"Ground"})

	player = Player( Vector(300,100))
	camera = Camera(player.pos.x, player.pos.y, 0.7)

	spawnPosition =  Vector(900, 550) 
	Timer.add( math.random( 0.5, 3 ), function ()
		self:spawnHuman()
	end)

end

function game:humanTimeout( human )
	if human ~= nil and not human.dead then
		if human.pos.x < player.pos.x - 1200 then
			human:destroy()
		else
			Timer.add(15, function() self:humanTimeout( human )  end)
		end
	end
end

function game:spawnHuman()
	if ( humanLimit > 0 ) then
		spawnPosition = Vector( math.max(spawnPosition.x, player.pos.x + 1200) 
								+ math.random(36, 108), spawnPosition.y )

		local human = Human( spawnPosition  )
		table.insert(objects, human)
		Timer.add(30, function() self:humanTimeout( human )  end)
		humanLimit = math.max( humanLimit - 1, 0 )
	end
	Timer.add( math.random( 0.5, 3 ), function ()
		self:spawnHuman()
	end)
end

function game:enter()
end

function beginContact(a, b, coll)
	local userDataA = a:getUserData()
	local userDataB = b:getUserData()
	if type(userDataA) == "table" and type(userDataB) == "table" then
		if userDataA[1] == "Player" and  userDataB[1] == "Human" then
			local body = b:getBody()
			local normalX =  coll:getNormal()
			body:applyLinearImpulse( normalX * .01 * math.random(5,8), math.random(4,10))
			local human = userDataB[2]
			if human:hit() then
				gui:addKill( human.id )
			end
		
		
			table.insert(activeEffects,BloodSplatter( Vector(body:getX(), body:getY()) ))
			Timer.add( 5, function()
					activeEffects[1].particleSystem:stop()
					table.remove( activeEffects, 1 )
				end)
		
		elseif userDataA[1] == "Ground" and userDataB[1] == "Player" and (
				( userDataB[2].angle > 3 and userDataB[2].angle < 3.28 ) or
				( userDataB[2].angle < -3 and userDataB[2].angle > -3.28 )
				) then
			Gamestate.switch( states.error )
		end
	end
end

function endContact(a, b, coll)
	
end

function preSolve(a, b, coll)
	
end

function postSolve(a, b, coll)
	
end

function game:update( dt )
	world:update(dt)
	Timer.update(dt)
	--update objects
	for i, object in pairs(objects) do
		if object.dead == true then
			if object:is_a( Human ) then
				humanLimit = humanLimit + 1
				local parts = object:createParts()
				for _, part in pairs( parts ) do
					table.insert( objects, part )
					part.body:applyLinearImpulse( 0.01 * math.random(1,7), -0.01 *  math.random(4,10))
					Timer.add( 5, function () part:destroy() end )
				end
			end
			table.remove( objects, i )
		else
			object:update(dt)
		end
	end

	player:update(dt)

	smoothFollow(camera, Vector(player.reindeer.body:getX(), player.reindeer.body:getY()), dt, 16, 400, 4 )

	
	game:handleInput(dt)
	
	self:updateBackground(dt)
	--update effects
	for i, effect in pairs(activeEffects) do
		effect:update(dt)
	end

	gui:update(dt)
end

function game:handleInput(dt)
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
		force.y = dir.y * player.yForce * 3000 * dt
		player.yForce = player.yForce * (1 - dt*1.5)
	elseif dir.y > 0 then
		force.y = dir.y * 10000 *dt
		player.yForce = math.min (player.yForce * (1 + dt*2), 100)
	else
		player.yForce = math.min (player.yForce * (1 + dt*2), 100)
	end
	if force:len() ~= 0 then
		player.reindeer.body:applyForce(force.x, force.y)
		player.sleigh.body:applyForce(0, force.y/3)
	end
end
function game:keypressed( key )
	if key == "escape" then
		Gamestate.switch( states.start )
	end
end


function game:draw()
	camera:attach()
	
	--love.graphics.polygon("fill", ground.body:getWorldPoints(ground.shape:getPoints()))

	self:drawBackground()

	
	for _, object in pairs(objects) do
		--love.graphics.polygon("fill", object.body:getWorldPoints(object.shape:getPoints()))
		object:draw()
	end


	--love.graphics.polygon("fill", player.sleigh.body:getWorldPoints(player.sleigh.shape:getPoints()))
	--love.graphics.polygon("fill", player.reindeer.body:getWorldPoints(player.reindeer.shape:getPoints()))
	player:draw()

	for _, effect in pairs(activeEffects) do
		effect:draw()
	end

	camera:detach()

	gui:draw()
end


function game:setupBackground()
	for i=1,5 do
		table.insert( backImages, love.graphics.newImage("assets/graphics/back"..i..".png"))
	end
	for i=1,4 do
		table.insert( floorImages, love.graphics.newImage("assets/graphics/street"..i..".png"))
	end

	for i=-1,2 do
		back[i] = backImages[ math.random( 1, # backImages) ]
		floor[i] = floorImages[ math.random( 1, # floorImages) ]
	end
		
end

function game:drawBackground()
	for i, image in pairs(back) do
		love.graphics.draw( back[i], 800 * i, -330)
	end
	for i, image in pairs(floor) do
		love.graphics.draw( floor[i], 512 * i, 400)
	end
end

function game:updateBackground(dt)
	local x = camera:pos()
	local xb = math.floor( x / 800 )
	local xf = math.floor( x / 512 )

	if back[ xb -3 ] ~= nil then
		back[ xb -3 ] = nil
	end
	if back[ xb + 2 ] == nil then
		back[ xb + 2 ] = backImages[ math.random( 1, # backImages ) ]
	end
	if floor[ xf -3 ] ~= nil then
		floor[ xf -3 ] = nil
	end
	if floor[ xf + 2 ] == nil then
		floor[ xf + 2 ] = floorImages[ math.random( 1, # floorImages ) ]
	end

end
return game
