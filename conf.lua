function love.conf(t)
	t.screen.width = 800
	t.screen.height = 600
	t.screen.fullscreen = false

	t.title = "unnamed"
	t.author = "Jonathan Wehrle"

	t.identity = "unnamed"

	t.version = "0.8.0"

	t.modules.joystick = false
	t.modules.physics = true

end
