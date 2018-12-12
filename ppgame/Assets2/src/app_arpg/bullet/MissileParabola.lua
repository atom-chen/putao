---------------
-- 抛物线
---------------
module("missile",package.seeall)

local clsMissileParabola = class("clsMissileParabola", clsMissileBase)

function clsMissileParabola:ctor(Uid, tMagicInfo, iOwnerID, casterSpr)
	clsMissileBase.ctor(self, Uid, tMagicInfo, iOwnerID, casterSpr)
end

function clsMissileParabola:dtor()
	
end

-- 飞出
function clsMissileParabola:OnShoot()
	local theOwner = self:GetOwner()
	local tMagicInfo = self:GetMagicInfo()
	local tTrackCfg = tMagicInfo and tMagicInfo.tTrackCfg
	assert(tTrackCfg.iMoveSpeed>0)
	assert(tTrackCfg.iMaxHeight>0)
	
	local xFrom, yFrom, hFrom = theOwner:getPosition3D()
	local flyDis = tTrackCfg.iMoveDis
	local Angle = theOwner:GetCurDir()+math.rad(tTrackCfg.iMoveDir)
	local total_frame = tTrackCfg.iMoveDis/tTrackCfg.iMoveSpeed
	local seconds = total_frame * GAME_CONFIG.SPF
	local moveVector = cc.pMul(cc.p(math.cos(Angle), math.sin(Angle)), flyDis)
	
	self:setPosition(xFrom, yFrom+hFrom)
	self.CurMoveSpeed = tTrackCfg.iMoveSpeed
	self.CurDir = Angle
	
	if self._mBody then
		self._mBody:runAction(cc.Sequence:create(
			cc.JumpBy:create(seconds, moveVector, tTrackCfg.iMaxHeight, 1), 
			cc.CallFunc:create(function()
				self._mBody = nil
				self:OnShootEnd()
			end),
			cc.RemoveSelf:create()
		))
	end
end

--@每帧更新
function clsMissileParabola:FrameUpdate(deltaTime)
	if self._mBody then 
		self.PosX, self.PosY = self._mBody:getPosition()
	end
end

return clsMissileParabola
