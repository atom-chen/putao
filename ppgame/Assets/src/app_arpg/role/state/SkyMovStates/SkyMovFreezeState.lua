clsSkyMovFreezeState = class("clsSkyMovFreezeState", clsSkyMovementState)

function clsSkyMovFreezeState:ctor()
	clsSkyMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKYMOVFREEZE
end

function clsSkyMovFreezeState:OnEnter(obj, args)
	obj:CreateTimerDelay("tmfreezesky", args.iFreeseTime, function()
		self:OnComplete(obj)
	end)
end

function clsSkyMovFreezeState:OnExit(obj)
	obj:DestroyTimer("tmfreezesky")
end

--@每帧更新
function clsSkyMovFreezeState:FrameUpdate(obj, deltaTime)
	
end

function clsSkyMovFreezeState:OnComplete(obj, args)
	if obj:IsInSky() then
		local param = {
			["jmpSpeed"] = 15,
		}
		obj:GetStateMgr():_SetSkyMovState(obj, ROLE_STATE.ST_SKYBRIDGE, {to_state = ROLE_STATE.ST_SKYMOVLINE, param = param})
	else
		obj:GetStateMgr():_SetSkyMovState(obj, ROLE_STATE.ST_SKYBRIDGE, {to_state = ROLE_STATE.ST_SKYMOVREST})
	end
end
