local bloodImg = love.graphics.newImage( "assets/graphics/blood.png" )

BloodSplatter = Class { name = "BloodSplatter", function(self, pos)
	self.pos = pos

	self.particleSystem = love.graphics.newParticleSystem( bloodImg, 100 )
	self.particleSystem:setPosition( pos.x ,pos.y  )

	self.particleSystem:setEmissionRate(40)
	self.particleSystem:setLifetime(0.2)
	self.particleSystem:setParticleLife(4)
	self.particleSystem:setDirection(0)
	self.particleSystem:setSpread(3)
	self.particleSystem:setSpeed(30, 70)
	self.particleSystem:setGravity(300)
	self.particleSystem:setRadialAcceleration(10)
	self.particleSystem:setTangentialAcceleration(0)
	self.particleSystem:setSizeVariation(0.5)
	self.particleSystem:setSizes( 0.5, 0.6, 0.7 )
	self.particleSystem:setRotation(0)
	self.particleSystem:setSpin(0)
	self.particleSystem:setSpinVariation(0)
	self.particleSystem:setColors(200, 200, 255, 240, 255, 255, 255, 10)
	self.particleSystem:start()
end}

function BloodSplatter:update(dt)
	self.particleSystem:update(dt)
end

function BloodSplatter:draw()
	love.graphics.draw( self.particleSystem, self.pos.x, self.pos.y )
end
