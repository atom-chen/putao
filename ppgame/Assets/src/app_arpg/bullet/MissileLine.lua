---------------
-- 直线
---------------
module("missile",package.seeall)

local clsMissileLine = class("clsMissileLine", clsMissileBase)

function clsMissileLine:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsMissileBase.ctor(self, Uid, tMagicInfo, iOwnerID, casterSpr)
end

function clsMissileLine:dtor()
	
end

-- 飞出
function clsMissileLine:OnShoot()
	local theOwner = self:GetOwner()
	local tMagicInfo = self:GetMagicInfo()
	local tTrackCfg = tMagicInfo and tMagicInfo.tTrackCfg
	
	local xFrom, yFrom, hFrom = theOwner:getPosition3D()
	
	local flyDis = tTrackCfg.iMoveDis
	local Angle = theOwner:GetCurDir()+math.rad(tTrackCfg.iMoveDir)
	local total_frame = tTrackCfg.iMoveDis/tTrackCfg.iMoveSpeed
	
	self:SetPosition3D(xFrom, yFrom, hFrom)
	self.CurMoveSpeed = tTrackCfg.iMoveSpeed
	self.CurDir = Angle
	
	self.deltaX = flyDis*math.cos(Angle)/total_frame
	self.deltaY = flyDis*math.sin(Angle)/total_frame
	self.iRemainFrame = total_frame
end

--@每帧更新
function clsMissileLine:FrameUpdate(deltaTime)
	self:setPosition(self.PosX+self.deltaX, self.PosY+self.deltaY)
	self.iRemainFrame = self.iRemainFrame - 1
	if self.iRemainFrame <= 0 then self:OnShootEnd() end
end

return clsMissileLine
