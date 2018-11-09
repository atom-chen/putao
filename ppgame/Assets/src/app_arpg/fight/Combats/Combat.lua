------------------
-- 战斗流程与规则定制
------------------
module("fight", package.seeall)

local function check_stop_reason(iReason)
	local bFlag = iReason==const.COMBAT_QUIT_REASON.RESULT or iReason==const.COMBAT_QUIT_REASON.TIMEOUT or iReason==const.COMBAT_QUIT_REASON.CLICK_QUIT
	assert(bFlag, "未知的结束原因: "..iReason)
end


clsCombat = class("clsCombat", clsCoreObject)

function clsCombat:ctor()
	clsCoreObject.ctor(self)
	
	self._curState = const.COMBAT_STATE_READY
	self.tFightResult = nil
	self.mTeamMgr = ClsTeamMgr.GetInstance()
	
	self:InitFinishTriger()
	self:InitTeams()
end

function clsCombat:dtor()
	if self.mTeamMgr then
		ClsTeamMgr.DelInstance()
		self.mTeamMgr = nil
	end
end

function clsCombat:InitTeams()
	local TeamList = FightService.GetInstance():GetFightArgu().tTeamList
	local InstRoleEntityMgr = ClsRoleEntityMgr.GetInstance()
	
	-- 创建各分组及成员
	for TeamId, RoleInfoList in pairs(TeamList) do
		local TeamObj = self.mTeamMgr:CreateGroup(TeamId)
		logger.fight("创建队伍：", TeamId)
		for j, RoleInfo in ipairs(RoleInfoList) do
			local fighterObj = InstRoleEntityMgr:UpdateFighter(RoleInfo)
			fighterObj:SetCurHP(fighterObj:GetMaxHP())
			TeamObj:AddMember(fighterObj)
			logger.fight("创建战士：", RoleInfo.Uid, fighterObj:GetRoleType())
		end
	end
	self:InitFighterSpr()
	
	-- 设置阵营关系
	self.mTeamMgr:SetGroupRelation(const.COMBAT_MYSIDE, const.COMBAT_OPSIDE, const.RELATION_ENEMY)
end

function clsCombat:InitFighterSpr()
	assert(false, "子类请重载")
end

function clsCombat:StartCombat()
	if self._curState ~= const.COMBAT_STATE_READY then return end 
	self._curState = const.COMBAT_STATE_FIGHT
	self.iStartTime = os.clock()
	g_EventMgr:FireEvent("START_COMBAT")
end

function clsCombat:StopCombat(iReason)
	check_stop_reason(iReason)
	if self._curState == const.COMBAT_STATE_OVER then 
		logger.error("已经停止了战斗！！！")
		return 
	end
	self._curState = const.COMBAT_STATE_OVER
	
	self:GenerateFightResult(iReason)
	
	if iReason == const.COMBAT_QUIT_REASON.RESULT then
		logger.warn("+++++++ 战斗结束：胜负已分")
	elseif iReason == const.COMBAT_QUIT_REASON.TIMEOUT then
		logger.warn("+++++++ 战斗结束：超时")
	elseif iReason == const.COMBAT_QUIT_REASON.CLICK_QUIT then
		logger.warn("+++++++ 战斗结束：点击退出")
	else 
		assert(false, "未知的结束原因: "..iReason)
	end
	logger.fight("----战斗结果：", self.tFightResult.bWin and "赢" or "输")
	logger.dump(self.tFightResult)
	
	FightService.GetInstance():OnCombatEnd(iReason)
	g_EventMgr:FireEvent("END_COMBAT", self.tFightResult)
end

function clsCombat:IsFinished()
	return self._curState == const.COMBAT_STATE_OVER
end 

function clsCombat:_TryFinish()
	if self:IsFinished() then return true end
	if self:CheckFinish() then
		self:StopCombat(const.COMBAT_QUIT_REASON.RESULT)
	end
	return self:IsFinished()
end

-- 定义尝试结束战斗的触发条件
function clsCombat:InitFinishTriger()
	g_EventMgr:AddListener(self, "ROLE_DIE", function(thisObj, uid)
		self:_TryFinish()
	end)
end

--检查战斗是否结束
function clsCombat:CheckFinish()
	assert(false, "override me")
end

--评判胜负
function clsCombat:Judge()
	assert(false, "override me")
end

--生成战斗结果信息
function clsCombat:GenerateFightResult(iReason)
	assert(not self.tFightResult, "已经统计过战斗结果")
	local useTime = os.clock() - self.iStartTime
	self.tFightResult = {
		bWin = self:Judge(),	--胜负
		iUseTime = useTime,		--用时
		iReason = iReason,		--结束原因
		iMaxDribble = 0,		--最大连击数
		iMaxDamage = 0,			--最大伤害值
		iOpDieCount = 0,		--敌方死亡数
		iOpHurtCount = 0,		--敌方伤残数
		iMeDieCount = 0,		--我方死亡数
		iMeHurtCount = 0,		--我方伤残数
	}
	return self.tFightResult
end

--获取战斗结果
function clsCombat:GetFightResult()
	return self.tFightResult
end

--判断某队伍是否所有成员都已经阵亡
function clsCombat:IsTeamDie(TeamId)
	return self.mTeamMgr:GetGroup(TeamId):IsAllDie() 
end

function clsCombat:GetTeamHP(TeamId)
	return self.mTeamMgr:GetGroup(TeamId):GetTotalHP()
end 

function clsCombat:GetTeamHpPercent(TeamId)
	return self.mTeamMgr:GetGroup(TeamId):GetHpPercent()
end 
