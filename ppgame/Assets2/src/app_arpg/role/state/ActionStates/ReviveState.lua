clsReviveState = class("clsReviveState", clsActionState)

function clsReviveState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_REVIVE
end

function clsReviveState:OnEnter(obj, args)
	local CurHP = args.CurHP or obj:GetMaxHP()
	obj:SetCurHP(CurHP)
	logger.state("复活", CurHP)
	obj:OnEnterState(self)
	
	obj:CreateAbsTimerDelay("tmrevive", 1, function()
		self:OnComplete(obj)
	end)
end

function clsReviveState:OnExit(obj)
	obj:DestroyTimer("tmrevive")
	if obj:GetMyPhysGroupID() then
		obj:AddToPhysWorld(obj:GetMyPhysGroupID())
	end
end

--@每帧更新
function clsReviveState:FrameUpdate(obj, deltaTime)

end

function clsReviveState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
end
