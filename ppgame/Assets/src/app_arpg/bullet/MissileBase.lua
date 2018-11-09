----------------------
-- 法术体基类
----------------------
module("missile",package.seeall)

clsMissileBase = class("clsMissileBase", clsCoreObject, phys.clsPhysBody)

function clsMissileBase:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsCoreObject.ctor(self)
	phys.clsPhysBody.ctor(self)
	assert(Uid, "Uid should not be nil")
	assert(iOwnerID, "iOwnerID should not be nil")
	assert(casterSpr, "casterSpr should not be nil")
	
	self.Uid = Uid
	self.tMagicInfo = tMagicInfo
	self.iOwnerID = iOwnerID
	self.casterSpr = casterSpr
	
	self.PosX = 0
	self.PosY = 0
	self.PosH = 0
	self.CurDir = 0
	self.CurMoveSpeed = 0
end

function clsMissileBase:dtor()
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	self:DestroyAllTimer()
	self:RemoveFromPhysWorld()
	self:_UnloadBody()
	if self.funcOnFlyOver then self.funcOnFlyOver(self.Uid) self.funcOnFlyOver = nil end
end

--@每帧更新
function clsMissileBase:FrameUpdate(deltaTime)
	
end

function clsMissileBase:_LoadBody()
	self:_UnloadBody()
	local info = {
		sResType = self.tMagicInfo.sResType,
		sResPath = self.tMagicInfo.sResPath,
		iPositionType = self.tMagicInfo.iPositionType,
		iLoopTimes = self.tMagicInfo.iLoopTimes,
		callback = function() 
			self._mBody = nil 
			ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
		end,
	}
	self._mBody = utils.CreateObject(nil, info)
	if not self._mBody then logger.error("load body failed") end
	gameutil.AddObj2Map(self._mBody,0,0)
end

function clsMissileBase:_UnloadBody()
	if self._mBody then
		KE_SafeDelete(self._mBody)
		self._mBody = nil
	end
end

-- 飞出
function clsMissileBase:Shoot(funcOnFlyOver)
	self.funcOnFlyOver = funcOnFlyOver
	local theOwner = self:GetOwner()
	if not theOwner then 
		logger.error("发射者不存在！！！")
		ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
		return false
	end
	
	self:_LoadBody()
	
	local GrpId = theOwner:GetMyPhysGroupID()
	if GrpId then self:AddToPhysWorld(-GrpId) end
	
	self:OnShoot()
	
	ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_BULLET)
	
	if self.tMagicInfo.tHarmFrame then
		for iFrame, tHarmInfo in pairs(self.tMagicInfo.tHarmFrame) do
			self:CreateTimerDelay(iFrame, iFrame, function()
				self:SetHarmInfo(tHarmInfo)
			end)
		end
	end
	
	return true 
end

function clsMissileBase:OnShoot()
	assert(false, "子类须重载")
end

function clsMissileBase:OnShootEnd()
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	self:DestroyAllTimer()
	self:RemoveFromPhysWorld()
	self:_UnloadBody()
	if self.funcOnFlyOver then self.funcOnFlyOver(self.Uid) self.funcOnFlyOver = nil end
	ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
end

---------------------------------------------
function clsMissileBase:SetPosition3D(x,y,h)
	self.PosX = x
	self.PosY = y
	self.PosH = h
	if self._mBody then self._mBody:setPosition(x,y) end
end

function clsMissileBase:setPosition(x,y)
	self.PosX = x
	self.PosY = y
	if self._mBody then self._mBody:setPosition(x,y) else logger.error("no body",debug.traceback()) end
end

---------------------------------------------
function clsMissileBase:getPosition3D() return self.PosX, self.PosY, self.PosH end
function clsMissileBase:getPosition() return self.PosX, self.PosY end
function clsMissileBase:GetPosX() return self.PosX end
function clsMissileBase:GetPosY() return self.PosY end
function clsMissileBase:GetPosH() return self.PosH end
function clsMissileBase:GetCurDir() return self.CurDir end
function clsMissileBase:GetCurMoveSpeed() return self.CurMoveSpeed end
function clsMissileBase:GetMagicInfo() return self.tMagicInfo end
function clsMissileBase:GetUid() return self.Uid end
function clsMissileBase:GetOwnerID() return self.iOwnerID end
function clsMissileBase:GetOwner() return ClsRoleEntityMgr.GetInstance():GetRole(self.iOwnerID) or nil end


---------------------------------------------
--@override
function clsMissileBase:OnCollision(body)

end

function clsMissileBase:AfterAttack(Victim, HarmInfo)
	assert(HarmInfo==self:GetHarmInfo())
	
	if HarmInfo.iIsSingleAtk == 1 then
		self:SetHarmInfo(false)
	else
		HarmInfo.tResults = HarmInfo.tResults or {}
		HarmInfo.tResults[Victim] = true
	end
	
	local theOwner = self:GetOwner()
	
	--------------------
	local AfterCollid = self.tMagicInfo.AfterCollid
	if not self:HasTimer("delme") then
		self:CreateTimerDelay("delme", 2, function()
			ClsMissileMgr.GetInstance():DestroyMissile(self.Uid)
		end)
	end
end
