clsSkillState = class("clsSkillState", clsActionState)

function clsSkillState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKILL
end

function clsSkillState:OnEnter(obj, args)
	local iSkillIndex = args.iSkillIndex
	local cbFinish = args.cbFinish
	obj.mSkillPack:CastSkill(iSkillIndex, args.sklArgu, function(iSkillId, stReason) 
		if cbFinish then cbFinish(iSkillId, stReason) end
		self:OnComplete(obj) 
	end)
end

function clsSkillState:OnExit(obj)
	obj:SetHarmInfo(false)
	if obj.mSkillPack:IsCastingSkill() then
		obj:BreakSkill()
	end
end

--@每帧更新
function clsSkillState:FrameUpdate(obj, deltaTime)
	
end

function clsSkillState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
	
	if obj:IsInSky() and obj:GetSkyMovState() ~= ROLE_STATE.ST_SKYMOVLINE then
		obj:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = 0,
		})
	end
end
