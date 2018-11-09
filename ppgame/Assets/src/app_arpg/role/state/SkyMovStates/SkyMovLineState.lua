clsSkyMovLineState = class("clsSkyMovLineState", clsSkyMovementState)

function clsSkyMovLineState:ctor()
	clsSkyMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKYMOVLINE
end

function clsSkyMovLineState:OnEnter(obj, args)
	assert(is_number(args.jmpSpeed))
	assert(args.cbFinish==nil or is_function(args.cbFinish))
	obj:SetCurSkySpeed(args.jmpSpeed)
	obj._jump_callback = args.cbFinish
end

function clsSkyMovLineState:OnExit(obj)
	obj:SetCurSkySpeed(0)
	obj._jump_callback = nil
end

--@每帧更新
function clsSkyMovLineState:FrameUpdate(obj, deltaTime)
	local JumpSpeed = obj:AddCurSkySpeed(-1)
	local newH = obj:GetPosH() + JumpSpeed
	
	if newH > 0 then
		obj:SetPosH(newH)
	else
		obj:SetPosH(0)
		self:OnComplete(obj)
	end
end

function clsSkyMovLineState:OnComplete(obj, args)
	assert(not obj:IsInSky(), "怎么还在空中我去")
	
	local jump_callback = obj._jump_callback
	obj._jump_callback = nil
	
	obj:GetStateMgr():_SetSkyMovState(obj, ROLE_STATE.ST_SKYBRIDGE, {to_state = ROLE_STATE.ST_SKYMOVREST})
	
	if obj:GetActState() == ROLE_STATE.ST_FLIGHT then
		obj:GetActStateObj():OnComplete(obj)
	else
		if obj:GetGrdMovState() == ROLE_STATE.ST_GRDMOVPATH then
			obj:Turn2ActState(ROLE_STATE.ST_RUN)
		else
			obj:Turn2ActState(ROLE_STATE.ST_IDLE)
		end
	end
	
	if jump_callback then
		jump_callback()
	end
end
