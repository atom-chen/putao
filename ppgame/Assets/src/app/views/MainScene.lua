
local MainScene = class("MainScene", cc.load("mvc").ViewBase)

function MainScene:onCreate()
    -- add HelloWorld label
    cc.Label:createWithSystemFont("Hello World", "Arial", 40)
        :move(display.cx, display.cy + 200)
        :addTo(self)
	for i=1, 11 do
		local spr = xianyou.TextureMerge:getInstance():createSprite("res/icon_"..i..".png",false)
		self:addChild(spr)
		local r = math.ceil(i/6)
		local c = i%6  if c==0 then c = 6 end
		spr:setPosition(c*100, r*100)
	end
end

return MainScene
