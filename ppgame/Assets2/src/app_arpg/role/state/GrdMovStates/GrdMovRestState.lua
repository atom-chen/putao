clsGrdMovRestState = class("clsGrdMovRestState", clsGrdMovementState)

function clsGrdMovRestState:ctor()
	clsGrdMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_GRDMOVREST
end

function clsGrdMovRestState:OnEnter(obj, args)
	--if obj:IsInSky() then logger.state("角色还在空中飘: "..obj:GetPosH()) end
end

function clsGrdMovRestState:OnExit(obj)
	
end

--@每帧更新
function clsGrdMovRestState:FrameUpdate(obj, deltaTime)
	
end
