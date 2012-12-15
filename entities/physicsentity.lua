PhysicsEntity = Class { name = "PhysicsEntity", inherits = Entity, function(self, pos, size, img, mass, imageOffset )
	Entity.construct( self, pos, size, img )
	self.angle = 0
	self.mass = mass or 0
	self.imageOffset = imageOffset or Vector(0,0)
	self.shape = love.physics.newRectangleShape( self.size.x, self.size.y )
	self.body = love.physics.newBody( world, self.pos.x, self.pos.y, "dynamic" )
	love.physics.newFixture(self.body, self.shape, mass)
end}

function PhysicsEntity:update(dt)
	self.pos.x = self.body:getX()
	self.pos.y = self.body:getY()
	self.angle = self.body:getAngle( )
end

function PhysicsEntity:draw(dt)
	local offset = self.imageOffset:rotated(self.angle )
	love.graphics.draw( self.image, self.pos.x + offset.x, self.pos.y + offset.y, self.angle )
end
