clsSkyMovRestState = class("clsSkyMovRestState", clsSkyMovementState)

function clsSkyMovRestState:ctor()
	clsSkyMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKYMOVREST
end

function clsSkyMovRestState:OnEnter(obj, args)
	assert(not obj:IsInSky(), "角色还在空中飘: "..obj:GetPosH())
	obj:Set_PosH(0)
end

function clsSkyMovRestState:OnExit(obj)
	
end

--@每帧更新
function clsSkyMovRestState:FrameUpdate(obj, deltaTime)
	
end