local start = Gamestate.new()

local startTimer = require "libs.hump.timer"

local bodyParts = {
	love.graphics.newImage( "assets/graphics/head1.png" ),
	love.graphics.newImage( "assets/graphics/head2.png" ),
}

local particleSystem
local text = { "PRESS ESCAPE", "DON'T PRESS ENTER" }
local activeText = 1

function start:init()
	startTimer.add( math.random( 5, 10), function() start:changeText() end)
end

function start:changeText()
	activeText = 2
	startTimer.add( math.random( 0.3, 1.5), function() activeText = 1 end)
	startTimer.add( math.random( 7, 21), function() start:changeText() end)
end

function start:chooseActive()
	if particleSystem ~= nil then
		particleSystem:stop()
	end
	particleSystem = particleSystems[ math.random( 1, #particleSystems ) ]
	particleSystem:start()

	startTimer.add( 1, function() self:chooseActive() end)
end

function start:update(dt)
	startTimer.update(dt)
	particleSystem:update(dt)
end

function start:enter()
	local i = math.random( 1, 2 )
	particleSystem = love.graphics.newParticleSystem( bodyParts[i], 256 )
	particleSystem:setPosition( 400, 600  )

	particleSystem:setEmissionRate(1)
	particleSystem:setLifetime(3600)
	particleSystem:setParticleLife(10)
	particleSystem:setDirection(1.6)
	particleSystem:setSpread(1)
	particleSystem:setSpeed(-50, -200)
	particleSystem:setGravity(30)
	particleSystem:setRadialAcceleration(10)
	particleSystem:setTangentialAcceleration(0)
	particleSystem:setSizeVariation(0.5)
	particleSystem:setSizes( 0.7, 1, 1.3 , 3)
	particleSystem:setRotation(0)
	particleSystem:setSpin(-.3,.3,.3)
	particleSystem:setColors(200, 200, 255, 240, 255, 255, 255, 10)
	
	particleSystem:start()
end
function start:leave()
	particleSystem:stop()
	particleSystem = nil
end

function start:draw()
	love.graphics.print( text[ activeText ], math.random(200, 202 ), math.random(100,102), math.random(.1, .2) , math.random( 3, 3.1 ), math.random( 3, 3.1 ))
	love.graphics.draw( particleSystem )
end

function start:keypressed( key )
	if key == "escape" then
		love.event.push('quit')
	elseif key == "return" then
		Gamestate.switch( states.game )
	end
end

return start
