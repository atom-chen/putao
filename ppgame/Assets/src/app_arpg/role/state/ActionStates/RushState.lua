clsRushState = class("clsRushState", clsActionState)

function clsRushState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_RUSH
end

function clsRushState:OnEnter(obj, args)
	obj:OnEnterState(self)
end

function clsRushState:OnExit(obj)
	obj:OnExitState(self)
end

--@每帧更新
function clsRushState:FrameUpdate(obj, deltaTime)

end