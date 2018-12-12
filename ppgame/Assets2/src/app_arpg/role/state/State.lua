-----------------------
-- 状态基类
-----------------------
clsState = class("clsState")

function clsState:ctor()
	self.Uid = "unknown"
	self.iStateLayer = -1
end

function clsState:dtor()
	
end

function clsState:GetUid()
	return self.Uid
end

--@每帧更新
function clsState:FrameUpdate(obj, deltaTime)
	
end

function clsState:OnEnter(obj, args)
	
end

function clsState:OnExit(obj)
	
end

function clsState:OnComplete(obj, args)
	assert(false, "Must Override Me")
end

----------------------------------------------------

clsSkyMovementState = class("clsSkyMovementState", clsState)

function clsSkyMovementState:ctor()
	clsState.ctor(self)
	self.iStateLayer = STATE_LAYER.TP_SKYMOVEMENT
end

----------------------------------------------------

clsGrdMovementState = class("clsGrdMovementState", clsState)

function clsGrdMovementState:ctor()
	clsState.ctor(self)
	self.iStateLayer = STATE_LAYER.TP_GRDMOVEMENT
end

----------------------------------------------------

clsActionState = class("clsActionState", clsState)

function clsActionState:ctor()
	clsState.ctor(self)
	self.iStateLayer = STATE_LAYER.TP_ACTION
end
