function CheckCollision(x1,y1,w1,h1, x2,y2,w2,h2)
  return x1 < x2+w2 and
         x2 < x1+w1 and
         y1 < y2+h2 and
         y2 < y1+h1
end

function love.load()
	player = {x=50, y=50, img=love.graphics.newImage('resources/playerSprite.png'), a=3.14, r=0, g=0, b=0}
	grass = love.graphics.newImage('resources/grass.png')
	mouse = {x=love.mouse.getX(), y=love.mouse.getY()}
	bullets = {}
	sTime = 5
	zs = {}
	score = 0
end

function love.draw()
	love.graphics.setColor(255,255,255)
	for i = 0, love.graphics.getWidth()/grass:getWidth() do
		for j = 0, love.graphics.getHeight()/grass:getHeight() do
			love.graphics.draw(grass, i * grass:getWidth(), j * grass:getHeight())
		end
	end


	love.graphics.setBackgroundColor(255,255,255)
	love.graphics.setColor(player.r, player.g, player.b)
	love.graphics.draw(player.img, player.x, player.y, player.a, 1, 1, 25, 25)
	love.graphics.print(player.x .. ' ' .. player.y, 0, 0)
	love.graphics.print(#bullets, 0, 25)

	for i,v in ipairs(zs) do
		love.graphics.setColor(50, 255, 50)
		love.graphics.rectangle('fill', v.x, v.y, 20, 20)
	end

	for i,v in ipairs(bullets) do
		love.graphics.setColor(0,0,0)
		love.graphics.rectangle('fill', v.x, v.y, 10, 10)
	end
end

function love.update(dt)
	sTime = sTime - dt
	if sTime <= 0 then
		sTime = 5
		z = {x=math.random(0, 750), y=math.random(0,550)}
		table.insert(zs, z)
	end
	mouse = {x=love.mouse.getX(), y=love.mouse.getY()}
	player.a = -(math.atan2((player.x-mouse.x),(player.y-mouse.y)))

	if love.keyboard.isDown('w') and player.y >= 0 then
		player.y = player.y - 350*dt
	end
	if love.keyboard.isDown('s') and player.y <= 600 then
		player.y = player.y + 350*dt
	end
	if love.keyboard.isDown('a') and player.x >= 0 then
		player.x = player.x - 350*dt
	end
	if love.keyboard.isDown('d') and player.x <= 800 then
		player.x = player.x + 350*dt
	end
	diff = {x=mouse.x-player.x, y=mouse.y-player.y}
	for i,v in ipairs(bullets) do
		v.x = v.x + diff.x*dt
		v.y = v.y + diff.y*dt
		if v.x <= 0 or v.x >= 800 or v.y <= 0 or v.y >= 600 then
			table.remove(bullets, i)
		end
	end
	for i,v in pairs(zs) do
		diff2 = {x=v.x - player.x, y = v.y - player.y}
		v.x = v.x - diff2.x*dt
		v.y = v.y - diff2.y*dt
	end

	for i,v in pairs(zs) do
		for t,m in pairs(bullets) do
			if CheckCollision(v.x, v.y, 20, 20, m.x, m.y, 10, 10) then
				table.remove(bullets, t)
				table.remove(zs, i)
				score = score + 1
			end
		end
	end

end

function love.mousepressed(x, y, button)
	if button == 'l' then
		b = {x=player.x, y=player.y}
		table.insert(bullets, b)
	end
end