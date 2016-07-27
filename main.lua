--[[
	Script by
		 ________  ________  ________ ________  ________  ________  _________   
		|\   ___ \|\   __  \|\  _____\\   __  \|\   __  \|\   ____\|\___   ___\ 
		\ \  \_|\ \ \  \|\  \ \  \__/\ \  \|\  \ \  \|\  \ \  \___|\|___ \  \_| 
		 \ \  \ \\ \ \   _  _\ \   __\\ \   _  _\ \  \\\  \ \_____  \   \ \  \  
		  \ \  \_\\ \ \  \\  \\ \  \_| \ \  \\  \\ \  \\\  \|____|\  \   \ \  \ 
		   \ \_______\ \__\\ _\\ \__\   \ \__\\ _\\ \_______\____\_\  \   \ \__\
		    \|_______|\|__|\|__|\|__|    \|__|\|__|\|_______|\_________\   \|__|
		                                                    \|_________|        
	Copyright © 2016, Mike Eling (#DRFR0ST)
]]

--[[
  __  __       _       
 |  \/  |     (_)      
 | \  / | __ _ _ _ __  
 | |\/| |/ _` | | '_ \ 
 | |  | | (_| | | | | |
 |_|  |_|\__,_|_|_| |_|

]]
                              
function love.load()
	--[[ Window & Mouse ]]--
		Window = {
			width = love.graphics.getWidth( ),
			height = love.graphics.getHeight(),
			focus = love.window.hasFocus(),
		}
		
		Mouse = {
			x = love.mouse.getX(),
			y = love.mouse.getY(),
		}

		love.mouse.setVisible(false)
		love.mouse.setGrabbed(true)
	--[[ ----- - ----- ]]--

	--[[ Game ]]--
		Game = {
			score = 0,
			active = true,
		}

		SFX = {
			Jump = love.audio.newSource("src/sfx/skok.wav", "stream"),
			Run = love.audio.newSource("src/sfx/run.wav", "stream"),
			EnmDie = love.audio.newSource("src/sfx/deadpotworow.wav", "stream"),
			Collect = love.audio.newSource("src/sfx/zbieranie.wav", "stream"),
		}
	--[[ ---- ]]--	

	--[[ Environment ]]--
		Environment = {
			Map = {
				grass = { -- 1 --
					imgA = love.graphics.newImage("src/img/map01.png"),
					imgB = love.graphics.newImage("src/img/map011.png"),
				},

				snow = { -- 2 --
					imgA = love.graphics.newImage("src/img/map02.png"),
					imgB = love.graphics.newImage("src/img/map022.png"),
				},

				dark = { -- 3 --
					imgA = love.graphics.newImage("src/img/map03.png"),
					imgB = love.graphics.newImage("src/img/map033.png"),
				},

				sand = { -- 4 --
					imgA = love.graphics.newImage("src/img/map04.png"),
					imgB = love.graphics.newImage("src/img/map044.png"),
				},

				mud = { -- 5 --
					imgA = love.graphics.newImage("src/img/map05.png"),
					imgB = love.graphics.newImage("src/img/map055.png"),
				},

				imgX_A = 0,
				imgW_A = 1280,

				imgX_B = -Window.width,
				imgW_B = 1280,

				active = 1,

				borderY = 225,
				borderYY = 340,

				speed = 230,
			},
		}
	--[[ ----------- ]]--

	--[[ Settings ]]--
		require("src/lib/AnAL")

		fpsGraph = require "FPSGraph"
		fps = fpsGraph.createGraph()
	--[[ -------- ]]--

	--[[ Player ]]--
		require "player"
    	p = Player:new()
	--[[ ------ ]]--	

	--[[ Enemy ]]--
		require "enemy"
		e = Enemy:new()
		e:spawn();
	--[[ ----- ]]--	

	--[[ Obstacle ]]--
		require "obstacles"
		oB = Obstacles:new()
		oB:spawn();
	--[[ ----- ]]--	

	--[[ Bonus ]]--
		require "bonus"
		b = Bonus:new()
		b:spawn()
	--[[ ----- ]]--	
 end

 function love.update( dt )
	 	Window.width = love.graphics.getWidth()
		Window.height = love.graphics.getHeight()
		Mouse.x = love.mouse.getX()
		Mouse.y = love.mouse.getY()
	--[[ ----- - ----- ]]--

		if(Game.active == true) then
			Environment.Map.speed = Environment.Map.speed + (dt + dt);

			Environment.Map.imgX_A = Environment.Map.imgX_A - Environment.Map.speed * dt
			Environment.Map.imgX_B = Environment.Map.imgX_B - Environment.Map.speed * dt

			if Environment.Map.imgX_A < 0 - Window.width then
				Environment.Map.imgX_A  = Environment.Map.imgX_B + Environment.Map.imgW_A		
			end
			if Environment.Map.imgX_B < 0 - Window.width then
				Environment.Map.imgX_B = Environment.Map.imgX_A + Environment.Map.imgW_B
			end

			p:update(dt);
			b:update(dt);
			oB:update(dt);
			e:update(dt);
		end

		

		fpsGraph.updateFPS(fps, dt)
	--[[ -------- ]]--
 end

 function love.draw()
 	love.graphics.draw(getActiveMap().imgA, Environment.Map.imgX_A, 0)
	love.graphics.draw(getActiveMap().imgB, Environment.Map.imgX_B, 0)
	
	--love.graphics.print("Y: "..p.y, 10, 10)

	e:draw();
	oB:draw();
	b:draw();
	p:draw();
 	--[[ -------- ]]--
 	--fpsGraph.drawGraphs({fps})
 end

--[[
  _____                   _       
 |_   _|                 | |      
   | |  _ __  _ __  _   _| |_ ___ 
   | | | '_ \| '_ \| | | | __/ __|
  _| |_| | | | |_) | |_| | |_\__ \
 |_____|_| |_| .__/ \__,_|\__|___/
             | |                  
             |_|                  
]]

function love.keypressed( key, isrepeat )
	if key == "tab" then
	  	local state = not love.mouse.isVisible()   -- the opposite of whatever it currently is
	  	love.mouse.setVisible(state)
	  	Game.active = not Game.active;

		local state = not love.mouse.isGrabbed()   -- the opposite of whatever it currently is
		love.mouse.setGrabbed(state) --Use love.mouse.setGrab(state) for 0.8.0 or lower
   	end

   	if(Game.active)then
   		p:keypressed( key, isrepeat );
   	end
end

function love.keyreleased( key )
	if key == "escape" then
		love.event.quit();
	end

	if key == "1" then
		Environment.Map.active = 1;
	elseif key == "2" then
		Environment.Map.active = 2;
	elseif key == "3" then
		Environment.Map.active = 3;
	elseif key == "4" then
		Environment.Map.active = 4;
	elseif key == "5" then
		Environment.Map.active = 5;
	end

	if(Game.active) then
		p:keyreleased( key )
	end
end

function love.textinput( text )

end

function love.mousefocus( f )

end

function love.mousepressed( x, y, button )

end

function love.mousereleased( x, y, button )

end

function love.mousemoved( x, y, dx, dy, istouch )

end

function love.touchpressed( id, x, y, dx, dy, pressure )

end

function love.touchreleased( id, x, y, dx, dy, pressure )

end

function love.touchmoved( id, x, y, dx, dy, pressure )
	
end

--[[
 __          ___           _               
 \ \        / (_)         | |              
  \ \  /\  / / _ _ __   __| | _____      __
   \ \/  \/ / | | '_ \ / _` |/ _ \ \ /\ / /
    \  /\  /  | | | | | (_| | (_) \ V  V / 
     \/  \/   |_|_| |_|\__,_|\___/ \_/\_/                                             
]]

function love.focus( f )

end

function love.visible( v )

end

function love.resize( w, h )

end

function love.threaderror( thread, errorstr )

end

function love.quit()

end

 --[[
  ______                _   _                 
 |  ____|              | | (_)                
 | |__ _   _ _ __   ___| |_ _  ___  _ __  ___ 
 |  __| | | | '_ \ / __| __| |/ _ \| '_ \/ __|
 | |  | |_| | | | | (__| |_| | (_) | | | \__ \
 |_|   \__,_|_| |_|\___|\__|_|\___/|_| |_|___/                                            
 ]]

function getActiveMap()
	if(Environment.Map.active == 1) then
		return Environment.Map.grass;
	elseif(Environment.Map.active == 2) then
		return Environment.Map.snow;
	elseif(Environment.Map.active == 3) then
		return Environment.Map.dark;
	elseif(Environment.Map.active == 4) then
		return Environment.Map.sand;
	elseif(Environment.Map.active == 5) then
		return Environment.Map.mud;
	end
	return 0;
end

function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end
 --[[
 ____________________________________
/                                    \

	$$$$$$$$\  $$$$$$\   $$$$$$\  
	$$  _____|$$  __$$\ $$  __$$\ 
	$$ |      $$ /  $$ |$$ /  \__|
	$$$$$\    $$ |  $$ |\$$$$$$\  
	$$  __|   $$ |  $$ | \____$$\ 
	$$ |      $$ |  $$ |$$\   $$ |
	$$$$$$$$\  $$$$$$  |\$$$$$$  |
	\________| \______/  \______/ 
                              
\____________________________________/
]]