clsDieState = class("clsDieState", clsActionState)

function clsDieState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_DIE
end

function clsDieState:OnEnter(obj, args)
	if obj:GetCurHP() ~= 0 then obj:SetCurHP(0) end
	obj:RemoveFromPhysWorld()
	obj:RemoveFromTeam()
	obj:OnEnterState(self)
	obj.mBuffMgr:OnDead()
	g_EventMgr:FireEvent("ROLE_DIE", obj:GetUid())
end

function clsDieState:OnExit(obj)
	obj:OnExitState(self)
end

--@每帧更新
function clsDieState:FrameUpdate(obj, deltaTime)

end