---------------
-- 附体
---------------
module("missile",package.seeall)

local clsMissilePossessed = class("clsMissilePossessed", clsMissileBase)

function clsMissilePossessed:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsMissileBase.ctor(self, Uid, tMagicInfo, iOwnerID, casterSpr)
end

function clsMissilePossessed:dtor()
	
end

-- 飞出
function clsMissilePossessed:OnShoot()
	local theOwner = self:GetOwner()
	local tMagicInfo = self:GetMagicInfo()
	local tTrackCfg = tMagicInfo and tMagicInfo.tTrackCfg
	
	self:setPosition(self.casterSpr:getPosition())
	self.CurMoveSpeed = self.casterSpr:GetCurMoveSpeed()
	self.CurDir = self.casterSpr:GetCurDir()
	self.iRemainFrame = tTrackCfg.iRemainFrame
end

--@每帧更新
function clsMissilePossessed:FrameUpdate(deltaTime)
	self:setPosition(self.casterSpr:getPosition())
	self.CurMoveSpeed = self.casterSpr:GetCurMoveSpeed()
	self.CurDir = self.casterSpr:GetCurDir()
	self.iRemainFrame = self.iRemainFrame - 1 
	if self.iRemainFrame <= 0 then self:OnShootEnd() end
end

return clsMissilePossessed
