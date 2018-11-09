clsWalkState = class("clsWalkState", clsActionState)

function clsWalkState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_WALK
end

function clsWalkState:OnEnter(obj, args)
	obj:OnEnterState(self)
end

function clsWalkState:OnExit(obj)
	
end

--@每帧更新
function clsWalkState:FrameUpdate(obj, deltaTime)
	
end