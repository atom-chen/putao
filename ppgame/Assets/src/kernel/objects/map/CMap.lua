----------------------------
-- 地图类
-- 瓦片下标从(0,0)开始，左下角为第0行第0列
-- 1024*1024 == 1M == (256*256*4)*4   即1个256*256的地图块为1/4M
----------------------------
local math_limit = math.Limit
local MAP_GRID_WIDTH = const.MAP_GRID_WIDTH
local MAP_GRID_HEIGHT = const.MAP_GRID_HEIGHT
local IS_MAP_EDIT_MODE = false

local LAYER_LAND = 1
local LAYER_OBJ = 2
local LAYER_WEATHER = 3

local MAX_TILE_COUNT = 32
local QUICK_INDEX = {}
for Row = 0, MAX_TILE_COUNT do
	QUICK_INDEX[Row] = {}
	for Col = 0, MAX_TILE_COUNT do
		QUICK_INDEX[Row][Col] = string.format("%d_%d", Row, Col)
	end
end

local InstTC = cc.Director:getInstance():getTextureCache()

clsMap = class("clsMap", clsLayer)

function clsMap:ctor(parent, map_id, bLockCamera)
	clsLayer.ctor(self, parent)
	
	self.tLayerList = {}
	self.iMapId = map_id
	self._bCameraLocked = bLockCamera and true or false 
	self.tMapBlockCache = {}
	self.tMapInfo = {}
	self.cur_blocks = {}
	self._r0 = -1
	self._c0 = -1
	self._r1 = -1
	self._c1 = -1
	self._xCenter = 0.01
	self._yCenter = 0.01
	self._x0 = 0
	self._y0 = 0
	self._x1 = 0
	self._y1 = 0
	
	self.mRootNode = cc.Layer:create()
	KE_SetParent(self.mRootNode, self)
	
	self:init_layers()
	self:ReadMapHeader()
	self:LoadPathFinder()
	
	VVDirector:SetMap(self)
	
	self:InitCompLoader()
	self:init_events()
	
	g_EventMgr:FireEvent("ENTER_MAP", map_id)
	
--	self:InitKeyBoardListener()
end

function clsMap:dtor()
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self) 
	self:BindCameraOn(nil)
	self._bCameraLocked = true
	
	g_EventMgr:FireEvent("LEAVE_MAP")
	
	if self.mCompLoader then
		KE_SafeDelete(self.mCompLoader)
		self.mCompLoader = nil 
	end
	
	for _, gamelayer in pairs(self.tLayerList) do
		KE_SafeDelete(gamelayer)
	end
	self.tLayerList = {}
	
	VVDirector:SetMap(nil)
end

function clsMap:init_layers()
	self.tLayerList[LAYER_LAND] = clsLayer.new(self.mRootNode)
	self.tLayerList[LAYER_OBJ] = clsLayer.new(self.mRootNode)
	self.tLayerList[LAYER_WEATHER] = clsLayer.new(self.mRootNode)
end

function clsMap:ReadMapHeader()
	--读取数据
	local filepath = string.format("map/header/%d.lua", self.iMapId)
	local data = setting.Get(filepath)
	assert(data.row_count<=MAX_TILE_COUNT and data.col_count<=MAX_TILE_COUNT, "最大瓦片行数和列数为："..MAX_TILE_COUNT)
	self.tMapInfo = {
		["tile_width"] = data.tile_width,			--瓦片宽
		["tile_height"] = data.tile_height,			--瓦片高
		["row_count"] = data.row_count,				--多少行瓦片
		["col_count"] = data.col_count,				--多少列瓦片
		["map_width"] = data.map_width,				--地图实际宽
		["map_height"] = data.map_height,			--地图实际高
		["img_format"] = data.img_format or "jpg",	--图片格式（jpg/png/tga/psd/...）
	}
	
	--限定相机坐标范围
	self._iMinCameraX = GAME_CONFIG.DESIGN_W_2
	self._iMinCameraY = GAME_CONFIG.DESIGN_H_2
	self._iMaxCameraX = self.tMapInfo.map_width - GAME_CONFIG.DESIGN_W_2-1
	self._iMaxCameraY = self.tMapInfo.map_height - GAME_CONFIG.DESIGN_H_2-1
	
	--根据索引获取地图块图片路径
	local map_index_2_path = {}
	for r = 0, MAX_TILE_COUNT do
		for c = 0, MAX_TILE_COUNT do
			local sIndex = QUICK_INDEX[r][c]
			map_index_2_path[sIndex] = string.format("map/image/%d/%s.%s", self.iMapId, sIndex, self.tMapInfo.img_format)
		end
	end
	self._map_index_2_path = map_index_2_path
end

function clsMap:LoadPathFinder()
	self._path_finder = utils.GetPathFinder()
	local bSucc = self._path_finder:loadBlock(string.format("map/mcm/%d.map", self.iMapId))
	self._b_loadblock_succ = bSucc
	
	if IS_MAP_EDIT_MODE then
		if not bSucc then
			self._path_finder:createBlock(math.ceil(data.map_width/MAP_GRID_WIDTH),math.ceil(data.map_height/MAP_GRID_HEIGHT))
		end
		self:ShowGrids()
	end
end

function clsMap:GetUid() return self.iMapId end
function clsMap:GetMapInfo() return self.tMapInfo end
function clsMap:GetMapWidth() return self.tMapInfo.map_width end
function clsMap:GetMapHeight() return self.tMapInfo.map_height end
function clsMap:GetTileWidth() return self.tMapInfo.tile_width end
function clsMap:GetTileHeight() return self.tMapInfo.tile_height end
function clsMap:GetWeatherLayer() return self.tLayerList[LAYER_WEATHER] end
function clsMap:IsLoadblockSucc() return self._b_loadblock_succ end 

function clsMap:WorldPos_2_Tile(world_x, world_y)
	return math.floor(world_y/self.tMapInfo.tile_height), math.floor(world_x/self.tMapInfo.tile_width)
end
function clsMap:Tile_2_WorldPos(r, c)
	-- 返回的是Tile左下角坐标点
	return c*self.tMapInfo.tile_width, r*self.tMapInfo.tile_height
end
function clsMap:WorldPos_2_ScreenPos(x, y)
	return x-self._x0, y-self._y0
end
function clsMap:ScreenPos_2_WorldPos(x, y)
	return self._x0+x, self._y0+y
end
function clsMap:WorldPos_2_GridPos(x,y)
	return math.floor(x/MAP_GRID_WIDTH), math.floor(y/MAP_GRID_HEIGHT)
end
function clsMap:GridPos_2_WorldPos(x,y)
	return x*MAP_GRID_WIDTH, y*MAP_GRID_HEIGHT
end
function clsMap:GetMapBlockIndex(r, c)
	return QUICK_INDEX[r][c]
end
function clsMap:GetMapBlockPath(r, c)
	return self._map_index_2_path[ QUICK_INDEX[r][c] ]
end
function clsMap:GetMapBlockPathByIndex(index)
	return self._map_index_2_path[index]
end

function clsMap:LoadBlockSync(r, c)
	local index = QUICK_INDEX[r][c]
	if not self.tMapBlockCache[index] then
		local res_path = self:GetMapBlockPath(r, c)
		self.tMapBlockCache[index] = cc.Sprite:create(res_path)
		self.tMapBlockCache[index]:setIgnoreAnchorPointForPosition(true)
		KE_SetParent(self.tMapBlockCache[index], self.tLayerList[LAYER_LAND])
		local x, y = self:Tile_2_WorldPos(r, c)
		self.tMapBlockCache[index]:setPosition(x, y)
	end
	
	self:LoadCfgData(r,c)
end

function clsMap:UnloadBlockSync(index)
	if self.tMapBlockCache[index] then
		KE_SafeDelete(self.tMapBlockCache[index])
		self.tMapBlockCache[index] = nil
		InstTC:removeTextureForKey(self:GetMapBlockPathByIndex(index))
	end
end

function clsMap:LoadBlockAsync(r, c)
	local index = QUICK_INDEX[r][c]
	if self.tMapBlockCache[index] then return end
	
	local function imageLoaded(texture)
		if self.tMapBlockCache[index] then return end
		self.tMapBlockCache[index] = cc.Sprite:createWithTexture(texture)
		self.tMapBlockCache[index]:setIgnoreAnchorPointForPosition(true)
		KE_SetParent(self.tMapBlockCache[index], self.tLayerList[LAYER_LAND])
		local x, y = self:Tile_2_WorldPos(r, c)
		self.tMapBlockCache[index]:setPosition(x, y)
		
	--	local LabelTest = cc.Label:createWithTTF(const.DEF_FONT_CFG(), index) 
	--	self.tMapBlockCache[index]:addChild(LabelTest)
	--	LabelTest:setAnchorPoint(cc.p(0,0))
	--	LabelTest:setPosition(1,1)
    end
	InstTC:addImageAsync(self:GetMapBlockPath(r, c), imageLoaded)
	
	self:LoadCfgData(r,c)
end

function clsMap:UnloadBlockAsync(index)
	if self.tMapBlockCache[index] then
		KE_SafeDelete(self.tMapBlockCache[index])
		self.tMapBlockCache[index] = nil
		InstTC:removeTextureForKey(self:GetMapBlockPathByIndex(index))
	else
		InstTC:unbindImageAsync(self:GetMapBlockPathByIndex(index))
	end
end

-- 输入：相机坐标
-- 确定可视区域
function clsMap:CalSeeableArea(xCenter, yCenter)
	if xCenter == self._xCenter and yCenter == self._yCenter then 
		return false 
	end
	xCenter = math_limit(xCenter, self._iMinCameraX, self._iMaxCameraX)
	yCenter = math_limit(yCenter, self._iMinCameraY, self._iMaxCameraY)
	if xCenter == self._xCenter and yCenter == self._yCenter then 
		return false 
	end
	
	self._xCenter = xCenter
	self._yCenter = yCenter
	self._x0 = xCenter - GAME_CONFIG.DESIGN_W_2
	self._y0 = yCenter - GAME_CONFIG.DESIGN_H_2
	self._x1 = self._x0 + GAME_CONFIG.DESIGN_W
	self._y1 = self._y0 + GAME_CONFIG.DESIGN_H
	
	return true
end

-- 加载可见地图块
function clsMap:UpdateCurBlocks()
	local r0, c0 = self:WorldPos_2_Tile(self._x0, self._y0)
	local r1, c1 = self:WorldPos_2_Tile(self._x1, self._y1)
	
	if self._r0>r0 or self._r1<r1 or self._c0>c0 or self._c1<c1 then
		r0 = r0-2  if r0<0 then r0=0 end
		c0 = c0-2  if c0<0 then c0=0 end
		r1 = r1+2  if r1>self.tMapInfo.row_count-1 then r1=self.tMapInfo.row_count-1 end
		c1 = c1+2  if c1>self.tMapInfo.col_count-1 then c1=self.tMapInfo.col_count-1 end
		self._r0,self._r1 = r0,r1
		self._c0,self._c1 = c0,c1
		
		self.visible_flag = not self.visible_flag
		
		local new_visible_flag = self.visible_flag
		local cur_blocks = self.cur_blocks
		
		for i=r0, r1 do
			for j=c0, c1 do
				self:LoadBlockAsync(i,j)
				cur_blocks[QUICK_INDEX[i][j]] = new_visible_flag
			end
		end
		
		for index, flag in pairs(cur_blocks) do
			if flag ~= new_visible_flag then 
				cur_blocks[index] = nil
				self:UnloadBlockAsync(index)
			end
		end
	end
end

function clsMap:SetCameraPos(x, y)
	if self:CalSeeableArea(x,y) then
		-- 通过反向移动地图的方式来模拟相机移动
		self:setPosition(-self._x0, -self._y0)
		-- 加载可见地图块
		self:UpdateCurBlocks()
	end
end

function clsMap:GetCameraPos()
	return self._xCenter, self._yCenter
end

function clsMap:FrameUpdate(deltaTime)
	if self._mCameraBinder then 
		self:SetCameraPos(self._mCameraBinder:getPosition())
	end
end

function clsMap:BindCameraOn(obj)
	if self._bCameraLocked then return end
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	self._mCameraBinder = obj
	if obj then
		ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_CAMERA)
	end
end

-- 锁定相机后，将禁止绑定相机跟随
function clsMap:LockCamera()
	self:BindCameraOn(nil)
	self._bCameraLocked = true
end

function clsMap:UnLockCamera()
	self._bCameraLocked = false
end

function clsMap:SetTouchMoveEnabled(bEnable)
	self._bTouchMoveEnabled = bEnable
	assert(not self._mCameraBinder, "尚未移除相机跟随")
end

function clsMap:GetCameraBinder()
	return self._mCameraBinder
end

------------------------------------------------------------

function clsMap:InitCompLoader()
	
end

function clsMap:LoadCfgData(r, c)
	
end

------------------------------------------------------------

function clsMap:Shake(seconds, degree, OnFinish)
	local delta = 0.03
	local actShakeOnce = cc.Sequence:create(
			cc.MoveTo:create(delta, cc.p(5, 20)), 
			cc.MoveTo:create(delta, cc.p(0, 0)), 
			cc.MoveTo:create(delta, cc.p(-5, -20)), 
			cc.MoveTo:create(delta, cc.p(0, 0)) )
			
	self.mRootNode:runAction(cc.Sequence:create(
		cc.Repeat:create(actShakeOnce, 6),
		cc.CallFunc:create(function()
			self.mRootNode:setPosition(0,0)
			if OnFinish then
				OnFinish()
			end	
		end)
	))
end

function clsMap:StopShake()
	self.mRootNode:stopAllActions()
	self.mRootNode:setPosition(0,0)
end

function clsMap:ShowGrids()
	local w,h = self._path_finder:getWidth(), self._path_finder:getHeight()
	for gridX=0, w-1 do 
		for gridY=0, h-1 do
			local key = gridX.."_"..gridY
			self._gridlist = self._gridlist or {}
			if not self._gridlist[key] then
				self._gridlist[key] = cc.Scale9Sprite:create("commons/others/mask_red.png")
				self._gridlist[key]:setAnchorPoint(cc.p(0,0))
				self._gridlist[key]:setContentSize(MAP_GRID_WIDTH,MAP_GRID_HEIGHT)
				self._gridlist[key]:setPosition(self:GridPos_2_WorldPos(gridX,gridY))
				KE_SetParent(self._gridlist[key], self.tLayerList[LAYER_WEATHER])
			end
			self._gridlist[key]:setVisible(self._path_finder:isBlock(gridX,gridY))
		end
	end
end

------------------------------------------------------------

function clsMap:AddObject(obj, x, y)
	if not obj then return false end
	KE_SetParent(obj, self.tLayerList[LAYER_OBJ])
	if x and y then 
		obj:setPosition(x, y) 
	end
	return true
end

function clsMap:RemoveObject(obj)
	if self._mCameraBinder == obj then
		self:BindCameraOn(nil)
	end
end

------------------------------------------------------------

function clsMap:OnTouchBegan(touch, event)
	if IS_MAP_EDIT_MODE then
		local ptTouch = touch:getLocation()
		local x, y = self:ScreenPos_2_WorldPos(ptTouch.x, ptTouch.y)	--等价于convertToNodeSpace
		local gridX, gridY = self:WorldPos_2_GridPos(x,y)
		self._multyX, self._multyY = gridX, gridY
	end
	return true
end

function clsMap:OnTouchMove(touch, event)
	if self._bTouchMoveEnabled then 
		local dt = touch:getDelta()
		self:SetCameraPos(self._xCenter-dt.x, self._yCenter-dt.y)
	end
end

function clsMap:OnTouchEnd(touch, event)
	local ptTouch = touch:getLocation()
	local x, y = self:ScreenPos_2_WorldPos(ptTouch.x, ptTouch.y)	--等价于convertToNodeSpace
		
	if IS_MAP_EDIT_MODE then
		local gridX, gridY = self:WorldPos_2_GridPos(x,y)
		if gridX==self._multyX and gridY==self._multyY then
			local bb = self._path_finder:isBlock(gridX, gridY)
			bb = not bb
			self._path_finder:setBlock(gridX, gridY, bb)
			
			local key = gridX.."_"..gridY
			self._gridlist = self._gridlist or {}
			if not self._gridlist[key] then
				self._gridlist[key] = cc.Scale9Sprite:create("commons/others/mask_red.png")
				self._gridlist[key]:setAnchorPoint(cc.p(0,0))
				self._gridlist[key]:setContentSize(MAP_GRID_WIDTH,MAP_GRID_HEIGHT)
				self._gridlist[key]:setPosition(self:GridPos_2_WorldPos(gridX, gridY))
				KE_SetParent(self._gridlist[key], self.tLayerList[LAYER_OBJ])
			end
			self._gridlist[key]:setVisible(bb)
		else
			local minX, maxX = math.min(gridX,self._multyX), math.max(gridX,self._multyX)
			local minY, maxY = math.min(gridY,self._multyY), math.max(gridY,self._multyY)
			for gridX=minX, maxX do
				for gridY=minY, maxY do
					self._path_finder:setBlock(gridX,gridY,true)
					
					local key = gridX.."_"..gridY
					self._gridlist = self._gridlist or {}
					if not self._gridlist[key] then
						self._gridlist[key] = cc.Scale9Sprite:create("commons/others/mask_red.png")
						self._gridlist[key]:setAnchorPoint(cc.p(0,0))
						self._gridlist[key]:setContentSize(MAP_GRID_WIDTH,MAP_GRID_HEIGHT)
						self._gridlist[key]:setPosition(self:GridPos_2_WorldPos(gridX, gridY))
						KE_SetParent(self._gridlist[key], self.tLayerList[LAYER_OBJ])
					end
					self._gridlist[key]:setVisible(true)
				end
			end
		end
	end
	
	local opTarget = ClsRoleSprMgr.GetInstance():GetHero()
	if opTarget and fight.FightService.GetInstance():IsClickToRun() then
		opTarget:DoRun(x,y,0)
	end
	
	local info = {
		sResType="particle",
		sResPath="effects/particle/SmallSun.plist",
		iPositionType=0x2,
		--callback = function() logger.normal("release particle") end
	}
	local obj = utils.CreateObject(nil, info)
	self:AddObject(obj,x,y)
end

function clsMap:init_events()
	local function onTouchBegan(touch, event)
		return self:OnTouchBegan(touch, event)
	end
	local function onTouchMoved(touch, event)
		self:OnTouchMove(touch, event)
	end
	local function onTouchEnded(touch, event)
		self:OnTouchEnd(touch, event)
	end
	local listener = cc.EventListenerTouchOneByOne:create()
	listener:registerScriptHandler(onTouchBegan, cc.Handler.EVENT_TOUCH_BEGAN)
	listener:registerScriptHandler(onTouchMoved, cc.Handler.EVENT_TOUCH_MOVED)
	listener:registerScriptHandler(onTouchEnded, cc.Handler.EVENT_TOUCH_ENDED)
	self:getEventDispatcher():addEventListenerWithSceneGraphPriority(listener, self)
end

function clsMap:InitKeyBoardListener()
	local function MoveHero()
		local opTarget = self._mCameraBinder or ClsRoleSprMgr.GetInstance():GetHero()
		if not opTarget then return end
		
		local dx,dy = 0,0
		
		if keyboard:IsKeyPressed(cc.KeyCode.KEY_W) then
			dy = 150
		elseif keyboard:IsKeyPressed(cc.KeyCode.KEY_S) then
			dy = -150
		end
		if keyboard:IsKeyPressed(cc.KeyCode.KEY_D) then
			dx = 150
		elseif keyboard:IsKeyPressed(cc.KeyCode.KEY_A) then
			dx = -150
		end
		
		if dx~=0 or dy~=0 then
			if keyboard:IsKeyPressed(cc.KeyCode.KEY_SHIFT) then
				g_EventMgr:FireEvent("ROLE_HANDOP", opTarget, "DoRush", {dx=opTarget:getPositionX()+dx, dy=opTarget:getPositionY()+dy})
			else
				g_EventMgr:FireEvent("ROLE_HANDOP", opTarget, "DoRun", {dx=opTarget:getPositionX()+dx, dy=opTarget:getPositionY()+dy})
			end
		else
			opTarget:DoRest()
		end
	end
	
	local function onKeyPressed(thisObj, key_code, event)
		if IS_MAP_EDIT_MODE and keyboard:IsTheseKeyPressed({cc.KeyCode.KEY_CTRL,cc.KeyCode.KEY_S}) then
			self._path_finder:saveBlock(string.format("map/mcm/%d.map", self.iMapId))
		end
		
		local opTarget = self._mCameraBinder or ClsRoleSprMgr.GetInstance():GetHero()
		
		-- 移动
		if key_code == cc.KeyCode.KEY_A then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_D then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_W then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_S then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_SHIFT then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_K then
			if opTarget then
				opTarget:DoJump(opTarget:getPositionX(),opTarget:getPositionY())
			end
		end
		
		-- 技能
		if opTarget then
			if key_code == cc.KeyCode.KEY_1 then
				opTarget:DoSkill(1)
			elseif key_code == cc.KeyCode.KEY_2 then
				opTarget:DoSkill(2)
			elseif key_code == cc.KeyCode.KEY_3 then
				opTarget:DoSkill(3)
			elseif key_code == cc.KeyCode.KEY_4 then
				opTarget:DoSkill(4)
			elseif key_code == cc.KeyCode.KEY_5 then
				opTarget:DoSkill(5)
			elseif key_code == cc.KeyCode.KEY_SPACE then
				opTarget:DoDefend()
			end
		end
		
		-- 状态测试
		if opTarget then
			if key_code == cc.KeyCode.KEY_F1 then
				opTarget:TestHitBack()		--击退
			elseif key_code == cc.KeyCode.KEY_F2 then
				opTarget:TestHitFloat()		--浮空
			elseif key_code == cc.KeyCode.KEY_F3 then
				opTarget:TestFreeze()		--冻结
			elseif key_code == cc.KeyCode.KEY_F4 then
				opTarget:TestHit()			--受击
			elseif key_code == cc.KeyCode.KEY_F6 then
				opTarget:TestDie()			--死亡
			elseif key_code == cc.KeyCode.KEY_F7 then
				opTarget:TestRevive()		--复活
			elseif key_code == cc.KeyCode.KEY_F8 then
				opTarget:DoDefend()		--防御
			end
		end
	end
	
	local function onKeyReleased(thisObj, key_code, event)
		local opTarget = self._mCameraBinder or ClsRoleSprMgr.GetInstance():GetHero()
		
		if key_code == cc.KeyCode.KEY_A then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_D then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_W then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_S then
			MoveHero()
		elseif key_code == cc.KeyCode.KEY_SHIFT then
			MoveHero()
		end
	end
	
	g_EventMgr:AddListener(self, "KEYBOARD_PRESS", onKeyPressed)
	g_EventMgr:AddListener(self, "KEYBOARD_UNPRESS", onKeyReleased)
end

