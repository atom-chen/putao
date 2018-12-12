---------------
-- 追踪
---------------
module("missile",package.seeall)

local clsMissileTrack = class("clsMissileTrack", clsMissileBase)

function clsMissileTrack:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsMissileBase.ctor(self, Uid, tMagicInfo, iOwnerID, casterSpr)
end

function clsMissileTrack:dtor()
	
end

-- 飞出
function clsMissileTrack:OnShoot()
	local theOwner = self:GetOwner()
	local tMagicInfo = self:GetMagicInfo()
	local tTrackCfg = tMagicInfo and tMagicInfo.tTrackCfg
	assert(tTrackCfg.iMoveSpeed>0)
	
	local xFrom, yFrom, hFrom = theOwner:getPosition3D()
	
	self.iRemainFrame = tTrackCfg.iRemainFrame
	self:setPosition(xFrom, yFrom+hFrom)
	self.CurMoveSpeed = tTrackCfg.iMoveSpeed
	self.CurDir = 0
end

function clsMissileTrack:FrameUpdate()
	local moveVector
	local FlySpeed = self.CurMoveSpeed	--飞行速度
	local xFrom, yFrom = self.PosX, self.PosY
	local theOwner = self:GetOwner()
	local trackTarget = theOwner and theOwner:GetFightTarget()
	self.CurDir = theOwner:GetCurDir()
	
	if trackTarget then
		local fromPt = {x=xFrom,y=yFrom}
		local targetPt = cc.p(theOwner:GetFightTarget():getPosition())
		moveVector = cc.pSub(targetPt,fromPt)
		self.CurDir = math.Vector2Radian(moveVector.x, moveVector.y)
	elseif self.CurDir then
		local vX,vY = math.Radian2Vector(self.CurDir)
		moveVector = cc.p(vX,vY)
	end
		
	if moveVector then
		moveVector = cc.pMul(cc.pNormalize(moveVector), FlySpeed)
		self.CurDir = math.Vector2Radian(moveVector.x, moveVector.y)
		self:setPosition(xFrom+moveVector.x, yFrom+moveVector.y)
	end
	
	self.iRemainFrame = self.iRemainFrame - 1
	if self.iRemainFrame <= 0 then self:OnShootEnd() end
end

return clsMissileTrack
