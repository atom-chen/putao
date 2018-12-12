-------------------------
-- 场景
-------------------------
clsScene = class("clsScene", function() return cc.Scene:create() end)

function clsScene:ctor(world_id, map_id)
	self:EnableNodeEvents()
	self.iWorldId = world_id		--场景ID
	self.iMapId = map_id			--地图ID
	ClsSceneManager:GetInstance()._mCurScene = self
	keyboard:InitKeboardEvent(self)
	self:SetMapId(self.iMapId)
	self:InitUILayer(self)
--	self.addChild = nil
	self:InitSystemKeyboard()
end

function clsScene:dtor()
	
end

function clsScene:OnDestroy()
	self:DestroyUILayer()
	self:DestroyMap()
end

function clsScene:OnLoadingOver()
	
end

function clsScene:SetMapId(iMapId, bLockCamera)
	self.iMapId = iMapId
	if self.mMap and self.mMap:GetUid()==iMapId then return end
	
	self:DestroyMap()
	
	if self.iMapId then  
		self.mMap = clsMap.new(self, self.iMapId, bLockCamera)
	end
end

function clsScene:DestroyMap()
	if self.mMap then
		KE_SafeDelete(self.mMap)
		self.mMap = nil
	end
end

function clsScene:InitUILayer(Parent)
	local layerMgr = ClsLayerManager.GetInstance()
	layerMgr:InitLayer(const.LAYER_VIEW, self)
	layerMgr:InitLayer(const.LAYER_PANEL, self)
	layerMgr:InitLayer(const.LAYER_POPWND, self)
	layerMgr:InitLayer(const.LAYER_DLG, self)
	layerMgr:InitLayer(const.LAYER_TOAST, self)
	layerMgr:InitLayer(const.LAYER_DRAG, self)
	layerMgr:InitLayer(const.LAYER_GUIDE, self)
	layerMgr:InitLayer(const.LAYER_LOADING, self)
	layerMgr:InitLayer(const.LAYER_CLICKEFF, self)
	layerMgr:InitLayer(const.LAYER_WAITING, self)
	layerMgr:InitLayer(const.LAYER_TOPEST, self)
end

function clsScene:DestroyUILayer()
	ClsUIManager.GetInstance():DestroyAllWindow()
end

function clsScene:ShowMap(bShow)
	if self.mMap then self.mMap:setVisible(bShow) end
end



function clsScene:InitSystemKeyboard()
	if device.platform ~= "ios" then return end
	local eventDispatcher = cc.Director:getInstance():getEventDispatcher()
	
	local listener = cc.EventListenerCustom:create("sys_keyboard_willshow", function(event)
		local height = PlatformHelper.getAdjustHei()
		if height > 0 then 
			ClsLayerManager.GetInstance():StopFixLayer()
			KE_SetTimeout(1, function()
				ClsLayerManager.GetInstance():FixLayerPos(height+50, 0.2)
			end)
		end
	end )
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	local listener = cc.EventListenerCustom:create("sys_keyboard_didshow", function(event)
		local height = PlatformHelper.getAdjustHei()
		if height > 0 then 
			ClsLayerManager.GetInstance():StopFixLayer()
			KE_SetTimeout(1, function()
				ClsLayerManager.GetInstance():FixLayerPos(height+50)
			end)
		end
	end )
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	local listener = cc.EventListenerCustom:create("sys_keyboard_willhide", function(event)
		ClsLayerManager.GetInstance():StopFixLayer()
		KE_SetTimeout(1, function()
			ClsLayerManager.GetInstance():FixLayerPos(0, 0.2)
		end)
	end )
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self)

	local listener = cc.EventListenerCustom:create("sys_keyboard_didhide", function(event)
		ClsLayerManager.GetInstance():StopFixLayer()
		KE_SetTimeout(1, function()
			ClsLayerManager.GetInstance():FixLayerPos(0)
		end)
	end )
	eventDispatcher:addEventListenerWithSceneGraphPriority(listener, self) 
end

function syswnd_size_changed(sArg)
	KE_SetTimeout(1, function()
	--	if g_EventMgr then
	--		g_EventMgr:FireEvent("syswnd_size_changed", sArg)
	--	end
	end)
end

function sys_keyboard_willshow(sArg)
	if device.platform ~= "android" then return end
	KE_SetTimeout(2, function()
		local editH = tonumber(sArg)
		local editPosY = g_CurEditY or 80
		local keboardH = math.ceil( 1.7*PlatformHelper.getKeyboardHei() / 0.33 )
		if (keboardH > editPosY) then
			ClsLayerManager.GetInstance():FixLayerPos(keboardH-editPosY+5, 0.2)
		end
	end)
end

function sys_keyboard_willhide(sArg)
	if device.platform ~= "android" then return end
	KE_SetTimeout(1, function()
		ClsLayerManager.GetInstance():FixLayerPos(0, 0.2)
	end)
end
