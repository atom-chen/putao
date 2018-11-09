clsIdleState = class("clsIdleState", clsActionState)

function clsIdleState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_IDLE
end

function clsIdleState:OnEnter(obj, args)
	obj:OnEnterState(self)
end

function clsIdleState:OnExit(obj)
	obj:OnExitState(self)
end

--@每帧更新
function clsIdleState:FrameUpdate(obj, deltaTime)

end