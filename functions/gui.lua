local gui = {}

local img = {
	love.graphics.newImage("assets/graphics/head1.png"),
	love.graphics.newImage("assets/graphics/head2.png")
}

gui.kills = { 0, 0, {} }

gui.rotation = { math.random( 0, 2*math.pi ), math.random( 0, 2*math.pi) }

function gui:draw()
	if self.kills[1] + self.kills[2] < 37 then
		for i, id in pairs( gui.kills[3] ) do
			love.graphics.draw( img[id], 
				40 + ( i - 1 ) % 18  * 40,
				40 + math.floor( i / 19 ) * 40
			)
		end
	else
		love.graphics.draw( img[1], 37, 38, self.rotation[1], 1, 1, 17, 18 )
		love.graphics.draw( img[2], 35, 74, self.rotation[2], 1, 1, 15, 14 )

		love.graphics.print( self.kills[1], 60, 20, 0, 2, 2 )
		love.graphics.print( self.kills[2], 60, 60, 0, 2, 2 )
	end
end

function gui:addKill( id )
	self.kills[id] = self.kills[id] + 1
	table.insert( gui.kills[3], id )
end

function gui:update(dt)
	if self.kills[1] + self.kills[2] > 36 then
		self.rotation[1] = self.rotation[1] + dt * math.random( 6, 12)
		self.rotation[2] = self.rotation[2] - dt * math.random(6, 12)
	end
end

return gui
