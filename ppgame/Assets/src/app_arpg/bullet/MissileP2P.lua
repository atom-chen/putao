---------------
-- 点到点
---------------
module("missile",package.seeall)

local clsMissileP2P = class("clsMissileP2P", clsMissileBase)

function clsMissileP2P:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsMissileBase.ctor(self, Uid, tMagicInfo, iOwnerID, casterSpr)
end

function clsMissileP2P:dtor()
	
end

function clsMissileP2P:SetVictim(victim)
	self._victim = victim
end 

-- 飞出
function clsMissileP2P:OnShoot()
	local theOwner = self:GetOwner()
	local tMagicInfo = self:GetMagicInfo()
	local tTrackCfg = tMagicInfo and tMagicInfo.tTrackCfg
	
	local xFrom, yFrom, hFrom = theOwner:getPosition3D()
	local xTo, yTo, hTo = self._victim:getPosition3D()
	
	local flyDis = math.Distance(xFrom,yFrom+hFrom, xTo,yTo+hTo)
	local Angle = math.Vector2Radian(xTo-xFrom, yTo+hTo-yFrom-hFrom)
	local total_frame = flyDis/tTrackCfg.iMoveSpeed
	
	self:SetPosition3D(xFrom, yFrom, hFrom)
	self.CurMoveSpeed = tTrackCfg.iMoveSpeed
	self.CurDir = Angle
	
	self.deltaX = flyDis*math.cos(Angle)/total_frame
	self.deltaY = flyDis*math.sin(Angle)/total_frame
	self.iRemainFrame = total_frame
end

--@每帧更新
function clsMissileP2P:FrameUpdate(deltaTime)
	self:setPosition(self.PosX+self.deltaX, self.PosY+self.deltaY)
	self.iRemainFrame = self.iRemainFrame - 1
	if self.iRemainFrame <= 0 then self:OnShootEnd() end
end

return clsMissileP2P
