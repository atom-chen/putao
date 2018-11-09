--------------------------------
-- 技能类: 控制技能的播放
--
-- 技能 = 施法动作 + 法术体
-- 描述：什么动作 第几帧 哪个部位 发出法术体 法术体怎样运动
--------------------------------
module("fight", package.seeall)

local ST_SKILL_READY = 1
local ST_SKILL_PLAYING = 2
local ST_SKILL_FINISH = 3

local IsValidSkillId = function(v) assert(setting.T_skill_cfg[v] and setting.GetSkillPlayInfo(v)) end
local IsValidSkillIndex = function(v) assert(v>=1 and v<=const.MAX_SKILL_INDEX) end

clsSkillInstant = class("clsSkillInstant",clsCoreObject)

clsSkillInstant:RegSaveVar("iSkillId", IsValidSkillId)		-- 技能ID
clsSkillInstant:RegSaveVar("iSkillIndex", IsValidSkillIndex)	-- 技能位
clsSkillInstant:RegSaveVar("iLevel", TYPE_CHECKER.INT)		-- 等级

function clsSkillInstant:ctor(theOwner, SkillInfo)
	clsCoreObject.ctor(self)
	self:BatchSetAttr(SkillInfo)
	self.iCurState = ST_SKILL_READY		--技能阶段
	self.mOwner = theOwner				--施法者
end

function clsSkillInstant:dtor()
	if self.mXTree then
		KE_SafeDelete(self.mXTree)
		self.mXTree = nil
	end
end

function clsSkillInstant:GetOwner() return self.mOwner end
function clsSkillInstant:IsPlaying() return self.iCurState == ST_SKILL_PLAYING end

-- 播放技能
function clsSkillInstant:Play(sklArgu, cbFinish)
	local iSkillId = self:GetiSkillId()
	
	if self.iCurState == ST_SKILL_PLAYING then return end
	self.iCurState = ST_SKILL_PLAYING
	
	local theOwner = self.mOwner
	if not theOwner then 
		assert(false, "播放技能时没有施法者！！！")
		self:ToFinishState()
		return false
	end
	
	-- 面向攻击对象
	local fight_target = theOwner:GetFightTarget()
	if fight_target then
		theOwner:FaceTo(fight_target:getPosition())
	end
	
	-- 
	logger.fight(theOwner:Get_Uid(), "释放技能：", iSkillId)
	theOwner:DoSay(setting.T_skill_cfg[iSkillId].sSkillName)

	if self.mXTree then
		self.mXTree:Recover()
	else
		local tSkillPlayInfo = setting.GetSkillPlayInfo(iSkillId)
		self.mXTree = smartor.clsSmartTree.new()
		self.mXTree:BuildByInfo(tSkillPlayInfo)
	end
	
	local caster = ClsRoleSprMgr.GetInstance():GetRole(self.mOwner:Get_Uid())
	self.mXTree:GetContext():SetPerformer("starman", caster)
	
	self.mXTree:Play(function(reason) 
		self.iCurState = ST_SKILL_FINISH
		local stReason
		if reason == smartor.XTREE_FINISH_REASON.BREAKED then
			stReason = const.ST_REASON_BREAK
		else
			stReason = const.ST_REASON_COMPLETE
		end
		self.mXTree:GetContext():KickPerformer("starman")
--		logger.drama("技能播放完毕",stReason,iSkillId)
		if cbFinish then cbFinish(iSkillId, stReason) end
	end)

	return true
end

-- 中断
function clsSkillInstant:BreakSkill()
	self.mXTree:Stop()
end
