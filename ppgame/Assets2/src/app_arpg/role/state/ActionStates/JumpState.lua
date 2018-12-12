clsJumpState = class("clsJumpState", clsActionState)

function clsJumpState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_JUMP
end

function clsJumpState:OnEnter(obj, args)
	obj:OnEnterState(self)
end

function clsJumpState:OnExit(obj)
	
end

--@每帧更新
function clsJumpState:FrameUpdate(obj, deltaTime)
	
end
