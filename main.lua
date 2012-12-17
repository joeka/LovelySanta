Gamestate = require "libs.hump.gamestate"
Vector = require "libs.hump.vector"
Camera = require "libs.hump.camera"
Class = require "libs.hump.class"
Timer = require "libs.hump.timer"

require "libs.strict"

states = {}

function love.load()

	love.mouse.setVisible( false )

	states.start = require "states.start"
	states.game = require "states.game"
	states.error = require "states.error"
	
	Gamestate.registerEvents()
	Gamestate.switch( states.start )

end


