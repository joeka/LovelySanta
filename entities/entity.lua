Entity = Class { name = "Entity", function(self, pos, size, image )
	self.angle = 0
	self.pos = pos or Vector(0,0)
	self.size = size or Vector(0,0)
	self.image = image
end}

function Entity:setPos( pos )
	self.pos = pos
end

function Entity:move( delta )
	self.pos = self.pos + delta
end

function Entity:setImage( img )
	self.image = img
end

function Entity:update(dt)

end

function Entity:draw()
	if self.image ~= nil then
		love.graphics.draw( self.imgage, self.pos.x, self.pos.y, self.angle )
	else
		love.graphics.setColor( 255, 0, 0, 255 )
		love.graphics.rectangle( "fill", self.pos.x, self.pos.y, self.size.x, self.size.y )
	end
end
