clsLieState = class("clsLieState", clsActionState)

function clsLieState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_LIE
end

function clsLieState:OnEnter(obj, args)
	obj:CreateAbsTimerDelay("tm_st_lie", 1, function()
		self:OnComplete(obj)
	end)
end

function clsLieState:OnExit(obj)
	obj:DestroyTimer("tm_st_lie")
end

--@每帧更新
function clsLieState:FrameUpdate(obj, deltaTime)
	
end

function clsLieState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
end
