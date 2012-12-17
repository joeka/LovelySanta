local error = Gamestate.new()

local errorTimer = require "libs.hump.timer"
local text = {
	"YOU",
	"BROKE",
	"IT",
	"...",
	"YOU",
	"MONSTER",
	":(",
	":( !!!"
}
local activeText = 1

function error:init()
	errorTimer.add( 2, function() self:nextText() end)
end

function error:update(dt)

	errorTimer.update(dt)
end

function error:enter()
end
function error:leave()
end

function error:nextText()
	if activeText >= #text then
		love.event.push('quit')
	else
		activeText = activeText + 1
		errorTimer.add( 2, function() self:nextText() end)
	end
end

function error:draw()
	local color = {
		math.random( 0, 255), 
		math.random( 0, 255),
		math.random( 0, 255)
	}
	love.graphics.setBackgroundColor(color[1], color[2], color[3])
	love.graphics.setColor( 255 - color[1], 255 - color[2], 255 - color[3], 255)
	love.graphics.print( text[activeText], math.random( 100,130  ), math.random(200,220),0 , math.random( 10, 20 ), math.random( 10, 20 ))
end

function error:keypressed( key )
	if key == "escape" then
		love.event.push('quit')
	elseif key == "return" then
		Gamestate.switch( states.game )
	end
end

return error
