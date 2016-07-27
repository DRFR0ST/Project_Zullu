Player = {}

function Player:new()
local object = {
		image = love.graphics.newImage("src/img/walk_anim.png"),
		x = 0,
		y = 200,
		width = 105,
		height = 128,
		size = 0.48,
		canJump = true,
		lastPos = 200.0,
		ySpeed = 0,
		shadow = {
	    	size = ((105 * 0.48) / 2) + 5,
	    	x = 0,
	    	y = 0,
		},
    }
    object.anim = newAnimation(object.image, 105, 128, 0.15, 0)

    setmetatable(object, { __index = Player })
    return object
end

function Player:update(dt)
	self.anim:update(dt)

	if not love.keyboard.isDown("a") and not love.keyboard.isDown("f") and self.canJump == true then

		SFX.Run:setVolume(0.1)
		love.audio.setVolume(0.2)
		love.audio.play( SFX.Run )
	end

	if self.canJump == true then
		if love.keyboard.isDown("w") and not love.keyboard.isDown("a") and not love.keyboard.isDown("f") then
			self.y = self.y - (Environment.Map.speed + 30) * dt
		end

		if love.keyboard.isDown("s") and not love.keyboard.isDown("a") and not love.keyboard.isDown("f") then
			self.y = self.y + (Environment.Map.speed + 30) * dt
		end
	end

	if love.keyboard.isDown("a") and not love.keyboard.isDown("f") then
		self.x = self.x - Environment.Map.speed * dt
		if self.image ~= love.graphics.newImage("src/img/stand_anim.png") then
			self.image = love.graphics.newImage("src/img/stand_anim.png")
			self.anim = newAnimation(self.image, 105, 128, 0.15, 0)
		end
		love.audio.stop( SFX.Run )
	end

	if love.keyboard.isDown("f") and not love.keyboard.isDown("a") and self.canJump == true then
		self.x = self.x - Environment.Map.speed * dt
		if self.image ~= love.graphics.newImage("src/img/duck_anim.png") then
			self.image = love.graphics.newImage("src/img/duck_anim.png")
			self.anim = newAnimation(self.image, 105, 128, 0.15, 0)
		end
		love.audio.stop( SFX.Run )
	end

	if love.keyboard.isDown("d") and not love.keyboard.isDown("a") and not love.keyboard.isDown("f") then
		self.x = self.x + (Environment.Map.speed + 30) * dt
	end

	if self.x > Window.width then
		self.x = Window.width
	end

	if(self.y < Environment.Map.borderY and self.canJump)then
		self.y = Environment.Map.borderY - 1
	elseif (self.y - self.height > Environment.Map.borderYY) then
		self.y = Environment.Map.borderYY + self.height
	end		

	if self.canJump == false then
		self.y = self.y - (self.ySpeed * dt)
		self.shadow.size = self.shadow.size - ((self.ySpeed/8) * dt)
		self.ySpeed = self.ySpeed - (2250 * dt)

		if self.lastPos < self.y then
			self.canJump = true
			self.ySpeed = 0
			self.lastPos = 0

			self.image = love.graphics.newImage("src/img/walk_anim.png")
			self.anim = newAnimation(self.image, 105, 128, 0.15, 0)
		end
	end
end

function Player:draw()
	love.graphics.setColor( 0, 0, 0, 25 )

	if self.canJump == false then
		self.shadow.x = self.x + ((self.width * self.size) / 2)
	else
		self.shadow.x = self.x + ((self.width * self.size) / 2)
		self.shadow.y = self.y + (self.height * self.size)
	end

	--love.graphics.ellipse( "fill", self.x + (self.width / 2) - 27, self.y + 59, 22, 5 )
	love.graphics.ellipse( "fill", self.shadow.x, self.shadow.y, self.shadow.size, 5 )
	--love.graphics.circle( "fill", self.x, (self.y + self.height) - 30, (self.width / 2), 100 )
	love.graphics.setColor( 255, 255, 255, 255 )
	self.anim:draw(self.x, self.y, 0 , self.size, self.size)
end

function Player:keypressed( key, isrepeat )
	if key == "space" then
		self:jump();
	end
end

function Player:keyreleased( key )
	if key == "a" or key == "f" then
		self.image = love.graphics.newImage("src/img/walk_anim.png")
		self.anim = newAnimation(self.image, 105, 128, 0.15, 0)
	end
end

function Player:jump()
    if self.canJump then
    	self.lastPos = self.y
    	self.canJump = false
        self.ySpeed = 500
        self.image = love.graphics.newImage("src/img/jump_anim.png")
		self.anim = newAnimation(self.image, 105, 128, 0.15, 0)

		SFX.Jump:setVolume(0.7)
		SFX.Jump:play()
    end
end