local size = Vector( 36, 88 )
local mass = 0.01
local imageOffset = Vector( -24, -48 )

local bodyParts = {
	{
		head = love.graphics.newImage( "assets/graphics/head1.png" ),
		body = love.graphics.newImage( "assets/graphics/body1.png" ),
		arm = love.graphics.newImage( "assets/graphics/arm1.png" ),
		leg = love.graphics.newImage( "assets/graphics/leg1.png" )
	},
	{
		head = love.graphics.newImage( "assets/graphics/head2.png" ),
		body = love.graphics.newImage( "assets/graphics/body2.png" ),
		arm = love.graphics.newImage( "assets/graphics/arm2.png" ),
		leg = love.graphics.newImage( "assets/graphics/leg2.png" )
	}
}

Human = Class { name = "Human", inherits = PhysicsEntity, function(self, pos )
	self.id = math.random ( 1, 2)
	local img = love.graphics.newImage("assets/graphics/human"..self.id..".png")
	PhysicsEntity.construct( self, pos, size, img, 0.01, imageOffset )

	self.fixture:setRestitution(0.4)
	self.fixture:setUserData({"Human", self})

	self.hp = math.random(1, 3)
end}

function Human:hit()
	if self.hp <= 1 then
		self:destroy()
		return true
	else
		self.hp = self.hp - 1
		return false
	end
end

function Human:createParts()
	local parts = {}
	local offset = Vector( 4,-4 )
	for part, image in pairs( bodyParts[ self.id ] ) do
		local size = Vector( image:getWidth(), image:getHeight() )
		offset = offset + Vector( size.x, - size.y)
		table.insert ( parts, PhysicsEntity( self.pos + offset, size - Vector( 4, 4 ), image, 0.001, Vector( -2, -2) ) )
		if part == "arm" or part == "leg" then
			table.insert ( parts, PhysicsEntity( self.pos, size - Vector( 4, 4 ), image, 0.001, Vector( -2, -2) ) )
		end
	end
	return parts
end

function Human.destroyParts( parts )
	for i, part in pairs (parts) do
		part.fixture:destroy()
		part.body:destroy()

		parts[i] = nil
	end
end
