local size = Vector( 36, 88 )
local mass = 0.01
local imageOffset = Vector( -24, -48 )

Human = Class { name = "Human", inherits = PhysicsEntity, function(self, pos )
	self.id = math.random ( 1, 2)
	local img = love.graphics.newImage("assets/graphics/human"..self.id..".png")
	PhysicsEntity.construct( self, pos, size, img, 0.01, imageOffset )
end}

