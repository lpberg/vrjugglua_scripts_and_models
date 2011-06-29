CollisionSound = {
	peakCollisions = 0,
	framesSincePeak = 0,
	timeout = 15
}

function update()
	collisionSound = snx.SoundHandle("Collision")
	collisionSound:trigger(1)


	-- if not self.collisionSound then
		-- self.collisionSound = snx.SoundHandle("Collision")
	-- end

	-- if collisions > self.peakCollisions then
		-- self.peakCollisions = collisions
		-- self.framesSincePeak = 0
		-- self.collisionSound:trigger(1)
	-- end
end

update()