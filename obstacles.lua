Obstacles = {}

function Obstacles:new()
	local object = {
		texture = love.graphics.newImage("src/img/mapTile_039.png"),
		x = -420,
		y = -420,
		width = 64,
		height = 64,
		size = 1,
		speed = 230,
		collided = false,
		overGround = 0,
    }

	object.shadow = {
    	size = ((object.width * object.size) / 2) + 5,
    	x = 0,
    	y = 0,
	}

    setmetatable(object, { __index = Obstacles })
    return object;
end

function Obstacles:spawn()
	table.insert(self, {
		skin = self.texture,
		x = Window.width + love.math.random(self.width, 380),
		y = Environment.Map.borderY + love.math.random(0, Environment.Map.borderYY - self.width),
		width = self.width,
		height = self.height,
		size = self.size,
		overG = self.overGround,
		shadow = {
	    	size = ((self.width * self.size) / 2) + 5,
	    	x = self.x,
	    	y = self.y,			
		},
	})
end

function Obstacles:update(dt)
	local i, o
	for i, o in ipairs(self) do
		o.x = o.x - Environment.Map.speed * dt
		if(o.x + o.width < 0) then
			table.remove(self, i);
			if o.collided == false then self:spawn() end
		end

		if CheckCollision(o.shadow.x, o.shadow.y, o.shadow.size + (o.width * o.size), 5, p.shadow.x, p.shadow.y, (p.shadow.size), 5) and o.collided == false then
		--if CheckCollision(o.x, o.y, o.width * o.size, o.height * o.size, --[[p.x, p.y + ((p.height / 2) * p.size), (p.width * p.size), ((p.height / 2) * p.size)--]]p.shadow.x, p.shadow.y, (p.shadow.size), 5) and o.collided == false then
			self:spawn()			
			--o.skin = love.graphics.newImage("src/img/boxCoin_disabled.png")
			o.collided = true
			SFX.Collect:setVolume(0.7)
			SFX.Collect:play()
		end
	end
end

function Obstacles:draw()
	local i, o
	for i, o in ipairs(self) do
		love.graphics.setColor( 0, 0, 0, 0 )
		love.graphics.ellipse( "fill", o.shadow.x + ((o.width * o.size) / 2), o.shadow.y + o.overG, o.shadow.size - (o.overG / 4), 5 )
		--love.graphics.ellipse( "fill", o.x + ((o.width * o.size) / 2), o.y + (o.height * o.size), ((o.width * o.size) / 2) + 5, 5 )
		love.graphics.setColor( 255, 255, 255, 255 )
		love.graphics.draw(o.skin, o.x, o.y, 0, o.size, o.size)
	end
end