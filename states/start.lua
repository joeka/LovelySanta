local start = Gamestate.new()

function start:init()

end

function start:enter()

end

function start:draw()

end

function start:keypressed( key )
	if key == "escape" then
		love.event.push('q')
	else
		-- do something
	end
end
