clsSkyMovPathState = class("clsSkyMovPathState", clsSkyMovementState)

function clsSkyMovPathState:ctor()
	clsSkyMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKYMOVPATH
end

function clsSkyMovPathState:OnEnter(obj, args)
	assert(false, "尚未实现")
end

function clsSkyMovPathState:OnExit(obj)
	assert(false, "尚未实现")
end

--@每帧更新
function clsSkyMovPathState:FrameUpdate(obj, deltaTime)
	
end