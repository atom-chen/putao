-------------------
-- 技能管理器
-------------------
module("fight", package.seeall)

clsSkillPackRound = class("clsSkillPackRound")

function clsSkillPackRound:ctor(theOwner)
	assert(theOwner)
	self.mOwner = theOwner	--所属角色
	self.tCDList = {}		--技能CD信息
	self.mCurSkill = nil	--当前释放中的技能
	self.tSkillObjList = {}
	g_EventMgr:AddListener(self, "ROUND_END", self.OnRoundEnd, self)
end

function clsSkillPackRound:dtor()
	for _, SkillObj in pairs(self.tSkillObjList) do
		KE_SafeDelete(SkillObj)
	end
	self.tSkillObjList = {}
	self.mCurSkill = nil 
end

--@每帧更新
function clsSkillPackRound:FrameUpdate(deltaTime)
	
end

function clsSkillPackRound:OnRoundEnd(Rnd)
	local tCDList = self.tCDList
	for iSkillIndex, curCD in pairs(tCDList) do
		tCDList[iSkillIndex] = curCD - 1
		if tCDList[iSkillIndex] < 0 then tCDList[iSkillIndex] = 0 end
	end
end

function clsSkillPackRound:ResetCD()
	for iSkillIndex, skillObj in pairs(self.tSkillObjList) do 
		local iSkillId = self:GetSkillId(iSkillIndex)
		local iCD = setting.T_round_skill_cfg[iSkillId].iCD
		if iCD > 0 then
			self.tCDList[iSkillIndex] = iCD
		end
	end
end 


function clsSkillPackRound:UpdateSkill(SkillInfo)
	local iSkillIndex = SkillInfo.iSkillIndex
	if not self.tSkillObjList[iSkillIndex] then 
		self.tSkillObjList[iSkillIndex] = clsSkillRound.new(self.mOwner, SkillInfo)
	end
	return self.tSkillObjList[iSkillIndex]
end

-- 是否拥有某技能
function clsSkillPackRound:HasSkill(iSkillId)
	return self:GetSkillIndex(iSkillId) ~= nil
end

-- 根据技能索引获取技能ID
function clsSkillPackRound:GetSkillId(iSkillIndex)
	return self.tSkillObjList[iSkillIndex] and self.tSkillObjList[iSkillIndex]:GetiSkillId()
end

-- 根据技能ID获取技能索引
function clsSkillPackRound:GetSkillIndex(iSkillId)
	for iSkillIndex, SkillData in pairs(self.tSkillObjList) do
		if SkillData:GetiSkillId() == iSkillId then
			return iSkillIndex
		end
	end
	return nil
end

-- 是否正在释放技能
function clsSkillPackRound:IsCastingSkill()
	return self.mCurSkill~=nil and self.mCurSkill:IsPlaying() 
end

-- 判断某技能是否处于CD中
function clsSkillPackRound:IsSkillInCD(iSkillIndex)
	return self.tCDList[iSkillIndex] ~= nil and self.tCDList[iSkillIndex]>0 
end

----------------我是一条分割线---------------------------

-- 检测是否可以释放某技能
function clsSkillPackRound:IsSkillEnable(iSkillIndex)
	assert(iSkillIndex)
	if self:IsCastingSkill() then 
		logger.fight("上一技能尚未释放完毕", self.mOwner:Get_Uid())
		return false
	end
	if not self.tSkillObjList[iSkillIndex] then
		logger.fight("尚未学习该技能", self.mOwner:Get_Uid())
		return false
	end
	if self:IsSkillInCD(iSkillIndex) then
		logger.fight("技能CD中", self.mOwner:Get_Uid(), iSkillIndex, self.tCDList[iSkillIndex])
		self.mOwner:DoSay("我在CD")
		return false
	end
	if not self.mOwner then
		logger.fight("并没有施法者", self.mOwner:Get_Uid())
		return false 
	end
	
	return true
end

-- 释放技能
function clsSkillPackRound:CastSkill(iSkillIndex, sklArgu, cbFinish)
	if not self:IsSkillEnable(iSkillIndex) then return false end
	
	local iSkillId = self:GetSkillId(iSkillIndex)
	
	-- 开始CD
	local iCD = setting.T_round_skill_cfg[iSkillId].iCD
	if iCD > 0 then
		self.tCDList[iSkillIndex] = iCD
	end
	
	-- 释放技能
	self.mCurSkill = self.tSkillObjList[iSkillIndex]
	self.mCurSkill:Play(sklArgu, cbFinish)
	
	return true
end

-- 技能被打断
function clsSkillPackRound:BreakSkill(OnSkillBreaked)
	if self.mCurSkill then
		self.mCurSkill:BreakSkill()
		if OnSkillBreaked then
			OnSkillBreaked()
		end
	end
end
