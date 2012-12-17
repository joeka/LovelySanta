local bloodImg = love.graphics.newImage( "assets/graphics/blood.png" )

BloodSplatter = Class { name = "BloodSplatter", function(self, pos)
	self.lifeTime= .1

	self.particleSystem = love.graphics.newParticleSystem( bloodImg, 256 )
	self.particleSystem:setPosition( pos.x + 20, pos.y  )

	self.particleSystem:setEmissionRate(600)
	self.particleSystem:setLifetime(self.lifeTime)
	self.particleSystem:setParticleLife(2)
	self.particleSystem:setDirection(-.5)
	self.particleSystem:setSpread(1)
	self.particleSystem:setSpeed(300, 60)
	self.particleSystem:setGravity(300)
	self.particleSystem:setRadialAcceleration(10,50)
	self.particleSystem:setTangentialAcceleration(0)
	self.particleSystem:setSizeVariation(0.5)
	self.particleSystem:setSizes( 0.9, 1 )
	self.particleSystem:setRotation(0)
	self.particleSystem:setSpin(0)
	self.particleSystem:setSpinVariation(1)
	self.particleSystem:setColors(200, 200, 255, 240, 255, 255, 255, 10)
	
	self.particleSystem:start()
end}

function BloodSplatter:update(dt)
	self.particleSystem:update(dt)
end

function BloodSplatter:draw()
	love.graphics.draw( self.particleSystem )
end

