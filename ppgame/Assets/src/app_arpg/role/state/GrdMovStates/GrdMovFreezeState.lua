clsGrdMovFreezeState = class("clsGrdMovFreezeState", clsGrdMovementState)

function clsGrdMovFreezeState:ctor()
	clsGrdMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_GRDMOVFREEZE
end

function clsGrdMovFreezeState:OnEnter(obj, args)
	obj:CreateTimerDelay("tmfreezegrd", args.iFreeseTime, function()
		self:OnComplete(obj)
	end)
end

function clsGrdMovFreezeState:OnExit(obj)
	obj:DestroyTimer("tmfreezegrd")
end

--@每帧更新
function clsGrdMovFreezeState:FrameUpdate(obj, deltaTime)
	
end

function clsGrdMovFreezeState:OnComplete(obj, args)
	obj:GetStateMgr():_SetGrdMovState(obj, ROLE_STATE.ST_GRDBRIDGE, {to_state = ROLE_STATE.ST_GRDMOVREST})
end
