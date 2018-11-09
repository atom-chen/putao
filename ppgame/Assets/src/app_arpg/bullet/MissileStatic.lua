---------------
-- 静止
---------------
module("missile",package.seeall)

local clsMissileStatic = class("clsMissileStatic", clsMissileBase)

function clsMissileStatic:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsMissileBase.ctor(self, Uid, tMagicInfo, iOwnerID, casterSpr)
end

function clsMissileStatic:dtor()
	
end

-- 飞出
function clsMissileStatic:OnShoot()
	local theOwner = self:GetOwner()
	local tMagicInfo = self:GetMagicInfo()
	local tTrackCfg = tMagicInfo and tMagicInfo.tTrackCfg
	
	local xFrom, yFrom, hFrom = theOwner:getPosition3D()
	local Dis = tTrackCfg.iDis or 0
	local Angle = theOwner:GetCurDir()+math.rad(tTrackCfg.iAngle or 0)
	local Hei = tTrackCfg.iHei or 0
	
	self:SetPosition3D(xFrom+Dis*math.cos(Angle), yFrom+Dis*math.sin(Angle), Hei)
	self.CurMoveSpeed = 0
	self.CurDir = 0
	self.iRemainFrame = tTrackCfg.iRemainFrame
end

--@每帧更新
function clsMissileStatic:FrameUpdate(deltaTime)
	self.iRemainFrame = self.iRemainFrame - 1 
	if self.iRemainFrame <= 0 then self:OnShootEnd() end
end

return clsMissileStatic
