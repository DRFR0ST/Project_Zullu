Enemy = {}

function Enemy:new()
	local object = {
		texture = 0,
		x = 0,
		y = 200,
		width = 105,
		height = 128,
		size = 0.55,
		speed = 250,	
		animSpeed = 0.15,	
		overGround = 0,
    }

	object.shadow = {
    	size = ((object.width * object.size) / 2) + 5,
    	x = 0,
    	y = 0,
	}

    setmetatable(object, { __index = Enemy })
    return object;
end

function Enemy:spawn()
	local rand = love.math.random(1, 5);

    if ( rand == 1 ) then
    	self.texture = love.graphics.newImage("src/img/snail_anim.png");
    	self.width = 60
    	self.height = 40
    	self.size = 0.60
    	self.speed = Environment.Map.speed + 30
    	self.x = Window.width + love.math.random(self.width, 380)
    	self.y = Environment.Map.borderY + love.math.random(0, Environment.Map.borderYY - self.height)
    	self.overGround = 0
    	self.animSpeed = 0.15
    elseif( rand == 2 ) then
    	self.texture = love.graphics.newImage("src/img/ghost_walk.png");
    	self.width = 51
    	self.height = 73
    	self.size = 0.75
    	self.speed = Environment.Map.speed + 40
    	self.x = Window.width + love.math.random(self.width, 380)
    	self.y = Environment.Map.borderY + love.math.random(0, Environment.Map.borderYY - self.height)
    	self.overGround = 25
    	self.animSpeed = 0.15
    elseif( rand == 3 ) then
    	self.texture = love.graphics.newImage("src/img/spider_anim.png");
    	self.width = 77
    	self.height = 53
    	self.size = 0.60
    	self.speed = Environment.Map.speed + 30
    	self.x = Window.width + love.math.random(self.width, 380)
    	self.y = Environment.Map.borderY + love.math.random(0, Environment.Map.borderYY - self.height)
    	self.overGround = 0
    	self.animSpeed = 0.15
    elseif( rand == 4 ) then
    	self.texture = love.graphics.newImage("src/img/worm_anim.png");
    	self.width = 63
    	self.height = 23
    	self.size = 0.58
    	self.speed = Environment.Map.speed + 20
    	self.x = Window.width + love.math.random(self.width, 380)
    	self.y = Environment.Map.borderY + love.math.random(0, Environment.Map.borderYY - self.height)
    	self.overGround = 0
    	self.animSpeed = 0.15
   	elseif( rand == 5 ) then
    	self.texture = love.graphics.newImage("src/img/bat_walk.png");
    	self.width = 79
    	self.height = 47
    	self.size = 0.58
    	self.speed = Environment.Map.speed + 60
    	self.x = Window.width + love.math.random(self.width, 380)
    	self.y = Environment.Map.borderY + love.math.random(0, Environment.Map.borderYY - self.height)
    	self.overGround = 45
    	self.animSpeed = 0.35
    end

	table.insert(self, {
		skin = self.texture,
		anim = newAnimation(self.texture, self.width, self.height, 0.15, 0),
		x = self.x,
		y = self.y,
		width = self.width,
		height = self.height,
		size = self.size,
		speed = self.speed,
		index = rand,
		collided = false,
		overG = self.overGround,
		anSpeed = self.animSpeed,
		shadow = {
	    	size = ((self.width * self.size) / 2) + 5,
	    	x = self.x,
	    	y = self.y,			
		},
	})
end

function Enemy:update(dt)
	local i, o
	for i, o in ipairs(self) do
		o.anim:update(dt)
		o.x = o.x - o.speed * dt
		if(o.x + o.width < 0) then
			table.remove(self, i);
			if(o.collided == false) then self:spawn() end
		end

		if CheckCollision(o.shadow.x, o.shadow.y, o.shadow.size + (o.width * o.size) + 10, 5 + 10, p.shadow.x, p.shadow.y, (p.shadow.size), 5) and o.collided == false then
			if o.index == 1 then
				o.skin = love.graphics.newImage("src/img/snail_dead.png")
			elseif o.index == 2 then
				o.skin = love.graphics.newImage("src/img/ghost_dead.png")
			elseif o.index == 3 then
				o.skin = love.graphics.newImage("src/img/spider_dead.png")
			elseif o.index == 4 then
				o.skin = love.graphics.newImage("src/img/worm_dead.png")
			elseif o.index == 5 then
				o.skin = love.graphics.newImage("src/img/bat_dead.png")
				o.width = 70
			end	
			o.anim = newAnimation(o.skin, o.width, o.height, o.anSpeed, 0)	
			SFX.EnmDie:setVolume(0.8); 
			SFX.EnmDie:play();
			self:spawn()	
			o.speed = Environment.Map.speed
			o.collided = true
			o.y = o.y + o.overG;
			o.overG = 0;
		end
	end
end

function Enemy:draw()
	local i, o
	for i, o in ipairs(self) do
		o.shadow.x = o.x
		o.shadow.y = o.y + (o.height * o.size)

		love.graphics.setColor( 0, 0, 0, 25 )
		--love.graphics.ellipse( "fill", o.x + ((o.width * o.size) / 2), o.y + (o.height * o.size), ((o.width * o.size) / 2) + 5, 5 )
		love.graphics.ellipse( "fill", o.shadow.x + ((o.width * o.size) / 2), o.shadow.y + o.overG, o.shadow.size - (o.overG / 4), 5 )
		love.graphics.setColor( 255, 255, 255, 255 )
		o.anim:draw(o.x, o.y, 0 , o.size, o.size)
	end
end