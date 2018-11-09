----------------------
-- clsRoleBase: 游戏内角色对象基类
--
--[[
属性与方法：
1. 移动 
2. 旋转
3. 定义实体资源加载方式的抽象接口
]]--
--
----------------------
local tolua_isnull = tolua.isnull

clsRoleBase = class("clsRoleBase", clsNode, clsCoreObject)

function clsRoleBase:ctor(parent, entityObj)
	clsNode.ctor(self,parent)
	clsCoreObject.ctor(self)
	
	self._entityObj = entityObj	--
	self._mBody = nil 			--模型实体
	
	self._bIsShow = true
	self:InitEventListeners()
end

function clsRoleBase:dtor()
	self._entityObj = nil
	self._mBody = nil
end

function clsRoleBase:InitEventListeners()
	self._entityObj:AddListener(self, "PosX", self.OnPosX, self)
	self._entityObj:AddListener(self, "PosY", self.OnPosY, self)
	self._entityObj:AddListener(self, "PosH", self.OnPosH, self)
	self._entityObj:AddListener(self, "CurDir", self.OnCurDir, self)
end
function clsRoleBase:OnPosX(Value, old_value)
	self:__set_positionX(Value)
end
function clsRoleBase:OnPosY(Value, old_value)
	self:__set_positionY(Value)
end
function clsRoleBase:OnPosH(Value, old_value)
	if self._mBody then self._mBody:setPositionY(Value) end
end
function clsRoleBase:OnCurDir(Value, old_value)
	assert(false,"子类须重载")
end

function clsRoleBase:Show(bShow)
	assert(bShow ~= nil, "参数不对")
	if self._bIsShow == bShow then return end
	self._bIsShow = bShow
	self:setVisible(bShow)
end

function clsRoleBase:IsShow()
	return self._bIsShow
end

--------------------
-- 移动相关
--------------------
clsRoleBase.__set_position = cc.Node.setPosition
clsRoleBase.setPosition = function(self,x,y)
	self._entityObj:SetPosXSilent(x)
	self._entityObj:SetPosYSilent(y)
	self:__set_position(x,y)
end

clsRoleBase.__get_position = cc.Node.getPosition
clsRoleBase.getPosition = function(self)
	return self._entityObj:getPosition()
end

clsRoleBase.__set_positionX = cc.Node.setPositionX
clsRoleBase.setPositionX = function(self, x)
	if self._entityObj:GetPosX() == x then return end
	self._entityObj:SetPosXSilent(x)
	self:__set_positionX(x)
end

clsRoleBase.__get_positionX = cc.Node.getPositionX
clsRoleBase.getPositionX = function(self)
	return self._entityObj:GetPosX()
end

clsRoleBase.__set_positionY = cc.Node.setPositionY
clsRoleBase.setPositionY = function(self, y)
	if self._entityObj:GetPosY() == y then return end
	self._entityObj:SetPosYSilent(y)
	self:__set_positionY(y)
end

clsRoleBase.__get_positionY = cc.Node.getPositionY
clsRoleBase.getPositionY = function(self)
	return self._entityObj:GetPosY()
end

-- 位置：高度
clsRoleBase.SetPosH = function(self, h)
	self._entityObj:SetPosHSilent(h)
	if self._mBody then self._mBody:setPositionY(h) end
end

-- 位置：高度
clsRoleBase.GetPosH = function(self)
	return self._entityObj:GetPosH()
end

-- 虚拟三维位置
function clsRoleBase:SetPosition3D(x,y,h)
	self:setPosition(x,y)
	self:SetPosH(h)
end

-- 虚拟三维位置
function clsRoleBase:GetPosition3D()
	return self._entityObj:GetPosX(), self._entityObj:GetPosY(), self._entityObj:GetPosH()
end

-- 是否处在空中
function clsRoleBase:IsInSky() 
	return self._entityObj:GetPosH() > 0 
end


-- 设置水平方向速度
function clsRoleBase:SetCurMoveSpeed(iSpeed)
	self._entityObj:SetCurMoveSpeedSilent(iSpeed)
end

-- 获取水平方向速度
function clsRoleBase:GetCurMoveSpeed()
	return self._entityObj:GetCurMoveSpeed()
end

-- 设置竖直方向速度
function clsRoleBase:SetCurSkySpeed(iSpeed)
	self._entityObj:SetCurSkySpeedSilent(iSpeed)
end

-- 获取竖直方向速度
function clsRoleBase:GetCurSkySpeed()
	return self._entityObj:GetCurSkySpeed()
end

-- 增加竖直方向速度
function clsRoleBase:AddCurSkySpeed(iDelta)
	local newSpeed = self._entityObj:GetCurSkySpeed() + iDelta
	self._entityObj:SetCurSkySpeedSilent( newSpeed )
	return newSpeed
end

clsRoleBase.__runAction = cc.Node.runAction
clsRoleBase.runAction = function(self, act)
	print("【警告...】调用了clsRoleBase.runAction")
	local act__ = self:__runAction(act)
		
	self:CreateTimerLoop("tmr_sync_pos", 1, function()
		local x, y = self:__get_position()
		self._entityObj:SetPosXSilent(x)
		self._entityObj:SetPosYSilent(y)
		
		if tolua_isnull(act__) then 
			if not tolua_isnull(self) then
				local x, y = self:__get_position()
				self._entityObj:SetPosXSilent(x)
				self._entityObj:SetPosYSilent(y)
			end
			return true 
		end
	end)
		
	return act__ 
end

--------------------
-- 旋转相关
--------------------
-- 设置朝向
local DOUBLE_PI = math.pi*2
function clsRoleBase:SetCurDir(iDir)
	assert(iDir>=0 and iDir<=DOUBLE_PI)
	self._entityObj:SetCurDir(iDir)
end

-- 获取朝向
function clsRoleBase:GetCurDir()
	return self._entityObj:GetCurDir()
end

-- 面向坐标点(x,y)
function clsRoleBase:FaceTo(x, y)
	local sx, sy = self:getPosition()
	local dX, dY = x-sx, y-sy
	if dX == 0 and dY == 0 then return end
	self:SetCurDir( math.Vector2Radian(dX, dY) )
end

--------------------
-- 资源相关
--------------------
-- 加载躯体
function clsRoleBase:_LoadBody()
	assert(false, "子类请自行重载")
end

-- 卸载躯体
function clsRoleBase:_UnloadBody()
	assert(false, "子类请自行重载")
end

-- 获取躯体
function clsRoleBase:GetBody()
	return self._mBody
end

function clsRoleBase:GetBodyHeight()
	return self._entityObj:GetBodyHeight()
end
