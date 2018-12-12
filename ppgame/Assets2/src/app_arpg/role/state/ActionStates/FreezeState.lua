clsFreezeState = class("clsFreezeState", clsActionState)

function clsFreezeState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_FREEZE
end

function clsFreezeState:OnEnter(obj, args)
	obj:OnEnterState(self)
	obj:CreateTimerDelay("tmfreezeact", args.iFreeseTime, function()
		self:OnComplete(obj)
	end)
end

function clsFreezeState:OnExit(obj)
	obj:DestroyTimer("tmfreezeact")
	obj:OnExitState(self)
end

--@每帧更新
function clsFreezeState:FrameUpdate(obj, deltaTime)
	
end

function clsFreezeState:OnComplete(obj, args)
	if obj:IsInSky() then
		obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_FLIGHT})
	else
		obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
	end
end