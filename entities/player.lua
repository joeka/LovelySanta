local mass = 1
local sleighImage = love.graphics.newImage( "assets/graphics/sleigh.png" )
local reindeerImage = love.graphics.newImage( "assets/graphics/reindeer.png" )
local basehight = 460

Player = Class { name = "Player", function(self, pos )
	self.pos = pos or Vector (0,0)

	self.sleigh = PhysicsEntity( pos, Vector(256, 128), sleighImage, .5, Vector(-128, -64) ) 
	self.reindeer = PhysicsEntity( pos + Vector( 256, 0 ), Vector(256, 128), reindeerImage, 1, Vector(-128, -64) )
	self.joint = love.physics.newDistanceJoint( self.reindeer.body, self.sleigh.body, pos.x +100, pos.y, pos.x+ 156, pos.y , false )

	self.yForce = 10000

end}

function Player:update(dt)
	self.sleigh:update(dt)
	self.reindeer:update(dt)

end


function Player:draw()
	self.sleigh:draw()
	self.reindeer:draw()
end
