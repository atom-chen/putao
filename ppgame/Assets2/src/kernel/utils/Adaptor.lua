---------------------
-- 自适应方案
---------------------
module("utils", package.seeall)

function AdaptLayout(theView, topArea, bottomArea, autoArea, lineArea)
	FixScreen()
	theView:setContentSize(GAME_CONFIG.DESIGN_W, GAME_CONFIG.DESIGN_H)
	local RootView = ccui.Helper:seekWidgetByName(theView, "RootView")
	if RootView then
		RootView:setContentSize(GAME_CONFIG.DESIGN_W, GAME_CONFIG.DESIGN_H)
	--	RootView:forceDoLayout()
	end
	
--	topArea = topArea or theView:getChildByName("AreaTop") 
--	bottomArea = bottomArea or theView:getChildByName("AreaBottom")
--	autoArea = autoArea or theView:getChildByName("AreaAuto")
	topArea = topArea or ccui.Helper:seekWidgetByName(theView, "AreaTop") 
	bottomArea = bottomArea or ccui.Helper:seekWidgetByName(theView, "AreaBottom")
	autoArea = autoArea or ccui.Helper:seekWidgetByName(theView, "AreaAuto")
	lineArea = lineArea or ccui.Helper:seekWidgetByName(theView, "AreaLine")
	
	local topHeight = 0
	local bottomHeight = 0
	
	if topArea then
		topHeight = topArea:getContentSize().height
		topArea:setPositionY(GAME_CONFIG.DESIGN_H-(1-topArea:getAnchorPoint().y)*topHeight)
	end
	
	if bottomArea then
		bottomHeight = bottomArea:getContentSize().height
	end
	
	local wAuto = GAME_CONFIG.DESIGN_W
	local hAuto = GAME_CONFIG.DESIGN_H - topHeight - bottomHeight
	
	if autoArea then
		wAuto = autoArea:getContentSize().width
		autoArea:setContentSize(wAuto, hAuto)
		autoArea:setPositionY(bottomHeight+autoArea:getAnchorPoint().y*hAuto)
		local allChilds = autoArea:getChildren()
		if allChilds then
			local diff = GAME_CONFIG.HEIGHT_DIFF
			for _, obj in pairs(allChilds) do
				obj:setPositionY( obj:getPositionY() + diff )
			end
		end
	end
	if lineArea then
		lineArea:setPositionY(bottomHeight+hAuto)
	end
	
	return { wAuto=wAuto, hAuto=hAuto, hTop = topHeight, hBottom = bottomHeight }
end
