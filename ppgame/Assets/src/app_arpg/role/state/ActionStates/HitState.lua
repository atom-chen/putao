clsHitState = class("clsHitState", clsActionState)

function clsHitState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_HIT
end

function clsHitState:OnEnter(obj, args)
	obj:OnEnterState(self)
	
	obj:CreateTimerDelay("tm_st_hit", 8, function()
		self:OnComplete(obj)
	end)
end

function clsHitState:OnExit(obj)
	obj:DestroyTimer("tm_st_hit")
	obj:OnExitState(self)
end

--@每帧更新
function clsHitState:FrameUpdate(obj, deltaTime)

end

function clsHitState:OnComplete(obj, args)
	if obj:IsInSky() then
		obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_FLIGHT})
	else
		obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
	end
end
