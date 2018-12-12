clsRunState = class("clsRunState", clsActionState)

function clsRunState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_RUN
end

function clsRunState:OnEnter(obj, args)
	obj:OnEnterState(self)
end

function clsRunState:OnExit(obj)

end

--@每帧更新
function clsRunState:FrameUpdate(obj, deltaTime)

end