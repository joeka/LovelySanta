function smoothFollow(camera, pos, dt, minDistance, maxDistance, coefficient )
	local fancyOption = coefficient or 1
	local camMaxDist = maxDistance or 400
	local camMinDist = minDistance or 1
	local dist = pos:dist( Vector(camera.x, camera.y) )
	local dir = Vector(pos.x - camera.x, pos.y - camera.y)
	dir:normalize_inplace()
	
	if dist > camMaxDist then
		dir = dir * (-1) * ( dist - camMaxDist )
		camera:move( dir.x, dir.y )
	elseif dist > camMinDist then
		dir.x = dir.x * dt * dist * fancyOption
		dir.y = dir.y * dt * dist * fancyOption
		camera:move( dir.x, dir.y )
	end
end
