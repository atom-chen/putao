-------------------------
-- 行为树角色代理
-------------------------
local DOUBLE_PI = 2 * math.pi

clsRoleFighter = class("clsRoleFighter", clsRoleEntity, clsTeamMember, phys.clsPhysBody)
clsRoleFighter:RegisterEventType("ENTER_STATE")
clsRoleFighter:RegisterEventType("EXIT_STATE")
clsRoleFighter:RegisterEventType("FLIGHT_STEP")
clsRoleFighter:RegisterEventType("POP_SAY")

function clsRoleFighter:ctor(Uid,TypeId)
	clsRoleEntity.ctor(self,Uid,TypeId)
	clsTeamMember.ctor(self)
	phys.clsPhysBody.ctor(self)
	
	-- 状态
	self.mStateMgr = ClsStateMgr.GetInstance()
	self:ResetStates()
	-- 技能数据
	self:SwitchSkillPack()
	-- AI
	self.mBlackBoard = ai.clsBlackBoard.new(self)
	-- BUFF
	self.mBuffMgr = fight.clsBuffMgr.new(self)
	-- 事件
	self:AddListener(self, "CurHP", self.OnCurHP, self)
	g_EventMgr:AddListener(self, "START_COMBAT", self.OnStartCombat, self)
	g_EventMgr:AddListener(self, "END_COMBAT", self.OnEndCombat, self)
	g_EventMgr:AddListener(self, "ROUND_BEGIN", self.OnRoundBegin, self)
	g_EventMgr:AddListener(self, "ROUND_END", self.OnRoundEnd, self)
end

function clsRoleFighter:dtor()
	self:StopAI()
	KE_SafeDelete(self.mSkillPack) self.mSkillPack = nil
	KE_SafeDelete(self.mBlackBoard) self.mBlackBoard = nil
	KE_SafeDelete(self.mBuffMgr) self.mBuffMgr = nil
	self.mStateMgr = nil
	self:LeaveMap()
end

--@每帧更新
function clsRoleFighter:FrameUpdate(deltaTime)
	self.mStateMgr:FrameUpdate(self, deltaTime)
	self.mSkillPack:FrameUpdate(deltaTime)
	self.mBuffMgr:FrameUpdate(deltaTime)
end

function clsRoleFighter:SwitchSkillPack()
	local combatType = fight.FightService.GetInstance():GetCombatType()
	if combatType == const.COMBAT_TYPE.Instant or combatType == const.COMBAT_TYPE.NONE then
		self.mSkillPack = fight.clsSkillPackInstant.new(self)
		self.mSkillPack:UpdateSkill({iSkillIndex=1, iSkillId=1001, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=2, iSkillId=1002, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=3, iSkillId=1003, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=4, iSkillId=1004, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=5, iSkillId=1005, iLevel=1})
	elseif combatType == const.COMBAT_TYPE.Round then
		self.mSkillPack = fight.clsSkillPackRound.new(self)
		self.mSkillPack:UpdateSkill({iSkillIndex=1, iSkillId=11001, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=2, iSkillId=12001, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=3, iSkillId=21001, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=4, iSkillId=22001, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=5, iSkillId=22002, iLevel=1})
	elseif combatType == const.COMBAT_TYPE.Post then
		self.mSkillPack = fight.clsSkillPackInstant.new(self)
		self.mSkillPack:UpdateSkill({iSkillIndex=1, iSkillId=1001, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=2, iSkillId=1002, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=3, iSkillId=1003, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=4, iSkillId=1004, iLevel=1})
		self.mSkillPack:UpdateSkill({iSkillIndex=5, iSkillId=1005, iLevel=1})
	end
end 

-------------------------
-- 事件
-------------------------
function clsRoleFighter:OnCurHP(Value, oldValue)
	if Value <= 0 then self:Turn2ActState(ROLE_STATE.ST_DIE) end
end
function clsRoleFighter:OnStartCombat()
	self:SwitchSkillPack()
	self.mSkillPack:ResetCD()
	local combatType = fight.FightService.GetInstance():GetCombatType()
	if combatType == const.COMBAT_TYPE.Instant then
		self:StartAI(30, "bt_hero_fight")
	elseif combatType == const.COMBAT_TYPE.Round then
		
	elseif combatType == const.COMBAT_TYPE.Post then
		self:StartAI(5, "bt_post_fight")
	end
	self.mBuffMgr:OnStartCombat()
end
function clsRoleFighter:OnEndCombat()
	self:StopAI()
	self.mBuffMgr:OnEndCombat()
end

function clsRoleFighter:OnRoundBegin(Rnd)
	self.mBuffMgr:OnRoundBegin(Rnd)
end
function clsRoleFighter:OnRoundEnd(Rnd)
	self.mBuffMgr:OnRoundEnd(Rnd)
end

-------------------------
-- 寻路
-------------------------
function clsRoleFighter:SetRoadPath(roadpath) self._mRoadPath = roadpath end
function clsRoleFighter:GetRoadPath() return self._mRoadPath end
function clsRoleFighter:ClearRoadPath() self._mRoadPath = nil end

-------------------------
-- 状态
-------------------------
function clsRoleFighter:GetStateMgr() return self.mStateMgr end
function clsRoleFighter:IsInSky() return self:Get_PosH() > 0 end
function clsRoleFighter:IsDead() return self.iActState == ROLE_STATE.ST_DIE end
function clsRoleFighter:IsAlive() return self.iActState ~= ROLE_STATE.ST_DIE end
function clsRoleFighter:GetActState() return self.iActState end
function clsRoleFighter:GetGrdMovState() return self.iGrdMovState end
function clsRoleFighter:GetSkyMovState() return self.iSkyMovState end
function clsRoleFighter:GetActStateObj() return self.mActState end
function clsRoleFighter:GetGrdMovStateObj() return self.mGrdMovState end
function clsRoleFighter:GetSkyMovStateObj() return self.mSkyMovState end
function clsRoleFighter:IsHero() return self:Get_Uid()==ClsRoleEntityMgr.GetInstance():GetHeroId() end
function clsRoleFighter:GetBuffMgr() return self.mBuffMgr end 

function clsRoleFighter:ResetStates()
	self.mStateMgr:ResetStates(self)
end

function clsRoleFighter:Turn2ActState(iState, args)
	return self.mStateMgr:Turn2ActState(self, iState, args)
end
function clsRoleFighter:Turn2GrdMovState(iState, args)
	return self.mStateMgr:Turn2GrdMovState(self, iState, args)
end
function clsRoleFighter:Turn2SkyMovState(iState, args)
	return self.mStateMgr:Turn2SkyMovState(self, iState, args)
end

function clsRoleFighter:OnActStateChanged(oState)
	self.iActState = oState:GetUid()
	self.mActState = oState
end
function clsRoleFighter:OnGrdMovStateChanged(oState)
	self.iGrdMovState = oState:GetUid()
	self.mGrdMovState = oState
end
function clsRoleFighter:OnSkyMovStateChanged(oState)
	self.iSkyMovState = oState:GetUid()
	self.mSkyMovState = oState
end

function clsRoleFighter:OnEnterState(oState, args)
	self:FireEvent("ENTER_STATE", oState, args)
end
function clsRoleFighter:OnExitState(oState)
	self:FireEvent("EXIT_STATE", oState)
end

function clsRoleFighter:Revive(CurHP)
	self:Turn2ActState(ROLE_STATE.ST_REVIVE, {CurHP = CurHP})
end

-------------------
-- 角色行动力
-------------------

--站立
function clsRoleFighter:DoRest()
	if self:ProcCan2Rest() == ai.BTSTATE.FAIL then return false end
	self.mStateMgr:_SetActState(self, ROLE_STATE.ST_IDLE)
	self.mStateMgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVREST)
	return true
end

--冲刺
function clsRoleFighter:DoRush(dx, dy, distance, cbFinish)
	if self:ProcCan2Rush() == ai.BTSTATE.FAIL then return false end
	local sx, sy = self:getPosition()
	local roadpath = utils.FindPath(sx, sy, dx, dy, distance)
	if not roadpath then return false end
	
	self:SetCurMoveSpeed(self:GetRushSpeed())
	self.mStateMgr:_SetActState(self, ROLE_STATE.ST_RUSH)
	self.mStateMgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVPATH, {
		roadpath = roadpath, cbFinish = cbFinish
	})
	return true
end

--奔跑
function clsRoleFighter:DoRun(dx, dy, distance, cbFinish)
	if self:ProcCan2Run() == ai.BTSTATE.FAIL then return false end
	local sx, sy = self:getPosition()
	local roadpath = utils.FindPath(sx, sy, dx, dy, distance)
	if not roadpath then return false end
	
	self:SetCurMoveSpeed(self:GetRunSpeed())
	self.mStateMgr:_SetActState(self, ROLE_STATE.ST_RUN)
	self.mStateMgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVPATH, {
		roadpath = roadpath, cbFinish = cbFinish
	})
	return true
end

--行走
function clsRoleFighter:DoWalk(dx, dy, distance, cbFinish)
	if self:ProcCan2Walk() == ai.BTSTATE.FAIL then return false end
	local sx, sy = self:getPosition()
	local roadpath = utils.FindPath(sx, sy, dx, dy, distance)
	if not roadpath then return false end
	
	self:SetCurMoveSpeed(self:GetWalkSpeed())
	self.mStateMgr:_SetActState(self, ROLE_STATE.ST_WALK)
	self.mStateMgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVPATH, {
		roadpath = roadpath, cbFinish = cbFinish
	})
	return true
end

--跳跃
function clsRoleFighter:DoJump(dx, dy, distance, cbFinish)
	if self:ProcCan2Jump() == ai.BTSTATE.FAIL then return false end
	self:FaceTo(dx,dy)
	self.mStateMgr:_SetActState(self, ROLE_STATE.ST_JUMP)
	self.mStateMgr:_SetSkyMovState(self, ROLE_STATE.ST_SKYMOVLINE, {jmpSpeed = const.JMP_SPEED, cbFinish = cbFinish,})
	return true
end

--攻击
function clsRoleFighter:DoSkill(iSkillIndex, sklArgu, cbFinish)
	if self:ProcCan2Skill(iSkillIndex) == ai.BTSTATE.FAIL then return false end
	local args = { iSkillIndex=iSkillIndex, sklArgu=sklArgu, cbFinish=cbFinish }
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	return self:Turn2ActState(ROLE_STATE.ST_SKILL, args)
end

--收招
function clsRoleFighter:DoStopSkill()
	if self:ProcCan2StopSkill() == ai.BTSTATE.FAIL then return false end
	self:BreakSkill()
	return true
end

--防御
function clsRoleFighter:DoDefend(cbFinish)
	if self:ProcCan2Defend() == ai.BTSTATE.FAIL then return false end
	self.mStateMgr:_SetActState(self, ROLE_STATE.ST_DEFEND, {cbFinish=cbFinish})
	self.mStateMgr:_SetGrdMovState(self, ROLE_STATE.ST_GRDMOVREST)
	return true
end

--采集
function clsRoleFighter:DoGather(cbFinish)
	if self:ProcCan2Gather() == ai.BTSTATE.FAIL then return false end
end

--打坐
function clsRoleFighter:DoZazen(cbFinish)
	if self:ProcCan2Zazen() == ai.BTSTATE.FAIL then return false end
end


--说话
function clsRoleFighter:DoSay(words)
	self:FireEvent("POP_SAY", words)
end

--打断技能
function clsRoleFighter:BreakSkill()
	self.mSkillPack:BreakSkill()
end

----------------------------------
--- AI
----------------------------------
function clsRoleFighter:GetBlackBoard()
	return self.mBlackBoard
end

function clsRoleFighter:GetFightTarget()
	local FightTargetId = self:GetBlackBoard():GetFightTargetId()
	if not FightTargetId then return nil end
	local target = ClsRoleEntityMgr.GetInstance():GetRole(FightTargetId)
	if target and not target:IsDead() then
		return target
	else
		self:GetBlackBoard():SetFightTargetId(nil)
		return nil
	end
end

function clsRoleFighter:StartAI(interval, btname)
	self:CreateTimerLoop("tmrAI", interval, function()
		ai.ClsBTFactory.GetInstance():GetBT(btname):Execute(self, function() end)
	end)
end

function clsRoleFighter:StopAI()
	self:DestroyTimer("tmrAI")
end



function clsRoleFighter:ProcCan2Rest()
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_IDLE) and self.mStateMgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVREST) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2Rush()
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_RUSH) and self.mStateMgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVPATH) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2Run()
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_RUN) and self.mStateMgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVPATH) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2Walk()
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_WALK) and self.mStateMgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVPATH) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2Jump()
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_JUMP) and self.mStateMgr:Can2SkyMovState(self, ROLE_STATE.ST_SKYMOVLINE) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2Skill(iSkillIndex)
	iSkillIndex = iSkillIndex or self:GetBlackBoard():GetSkillIndex()
	if not self.mSkillPack:IsSkillEnable(iSkillIndex) then
		return ai.BTSTATE.FAIL
	end
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_SKILL) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2Defend()
	if self.mStateMgr:Can2ActState(self, ROLE_STATE.ST_DEFEND) and self.mStateMgr:Can2GrdMovState(self, ROLE_STATE.ST_GRDMOVREST) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

function clsRoleFighter:ProcCan2StopSkill()
	return ai.BTSTATE.SUCC
end

function clsRoleFighter:ProcCan2Gather()
	return ai.BTSTATE.FAIL
end

function clsRoleFighter:ProcCan2Zazen()
	return ai.BTSTATE.FAIL
end


-- 是否正在施法
function clsRoleFighter:ProcIsCastingSkill()
	if self:GetActState() == ROLE_STATE.ST_SKILL then
		return ai.BTSTATE.SUCC
	else 
		return ai.BTSTATE.FAIL
	end
end

-- 是否有战斗对象
function clsRoleFighter:ProcHasFightTarget()
	if self:GetFightTarget() ~= nil then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 敌人是否在技能范围内
function clsRoleFighter:ProcInSkillRange(iSkillIndex)
	iSkillIndex = iSkillIndex or self:GetBlackBoard():GetSkillIndex()
	local iSkillId = self.mSkillPack:GetSkillId(iSkillIndex)
	local skillRange = setting.GetSkillRange(iSkillId)
	if self:ProcCmpTargetDistance("le", skillRange) == ai.BTSTATE.SUCC then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 角色是否可被攻击
function clsRoleFighter:ProcIsTargetCanBeAttack(targetID)
	local targetObj = ClsRoleEntityMgr.GetInstance():GetRole(targetID)
	if targetObj and (not targetObj:IsDead()) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较敌人血量百分比
function clsRoleFighter:ProcCmpEnemyHP(sCmpType, percent)
	local target = self:GetFightTarget()
	if not target then return ai.BTSTATE.FAIL end
	if ai.AiCmp(sCmpType, target:GetHPPercent(), percent) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较敌人数量
function clsRoleFighter:ProcCmpEnemyNum(sCmpType, iNum)
	local count = self:GetEnemyCount()
	if ai.AiCmp(sCmpType, count, iNum) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较自己的血量百分比
function clsRoleFighter:ProcCmpSelfHP(sCmpType, percent)
	local selfHpPercent = self:GetHPPercent()
	if ai.AiCmp(sCmpType, selfHpPercent, percent) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较敌我距离和某个值
function clsRoleFighter:ProcCmpTargetDistance(sCmpType, iDistance)
	local target = self:GetFightTarget()
	if not target then return ai.BTSTATE.FAIL end
	
	local xTarget, yTarget = target:getPosition()
	local xSelf, ySelf = self:getPosition()
	local dis = (xTarget-xSelf)*(xTarget-xSelf) + (yTarget-ySelf)*(yTarget-ySelf)
	if ai.AiCmp(sCmpType, dis, iDistance*iDistance) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较友军数量和某个值
function clsRoleFighter:ProcCmpTeammateNum(sCmpType, iNum)
	if ai.AiCmp(sCmpType, self:GetTeammateCount(), iNum) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 血量低于某值时逃跑
function clsRoleFighter:ProcIsEscapeHP(iEscapeHP)
	if self:GetHPPercent() <= iEscapeHP then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较概率
function clsRoleFighter:ProcCmpRate(rate)
	if is_function(rate) then rate = rate(self) end
	assert(rate>=0 and rate<=1)
	local randValue = math.random(0, 1000)/1000
	if randValue <= rate then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较怒气值是否大于某值
function clsRoleFighter:ProcCmpAnger(sCmpType, iValue)
	if ai.AiCmp(sCmpType, self:GetAngerPower(), iValue) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 比较士气值
function clsRoleFighter:ProcCmpMorale(sCmpType, iValue)
	if ai.AiCmp(sCmpType, self:GetMorale(), iValue) then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end

-- 是否处于巡逻CD中
function clsRoleFighter:ProcIsInPatrolCd()
	if self:HasTimer("tm_ai_patrolcd") then
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end
end


-- 视野
function clsRoleFighter:ProcAOI(btNode, iRange)
	local enemy_teams = self:GetEnemyTeamList()
	if not enemy_teams then 
		self:GetBlackBoard():SetFightTargetId(nil)
		return ai.BTSTATE.FAIL 
	end
	
	local DistanceSquare = math.DistanceSquare
	local iRange_X_iRange = iRange * iRange
	for _, team in pairs(enemy_teams) do
		local member_list = team:GetMemberList()
		if member_list then
			for _, enemy in pairs(member_list) do
				if not enemy:IsDead() and DistanceSquare(self, enemy) <= iRange_X_iRange then
					self:GetBlackBoard():Set_FightTargetId(enemy:Get_Uid())
					return ai.BTSTATE.SUCC
				end
			end
		end
	end
	
	self:GetBlackBoard():SetFightTargetId(nil)
	return ai.BTSTATE.FAIL
end

-- 距离最近的敌人
function clsRoleFighter:ProcFindNearestEnemy(btNode)
	local enemy_teams = self:GetEnemyTeamList() 
	if not enemy_teams then
		self:GetBlackBoard():SetFightTargetId(nil)
		return ai.BTSTATE.FAIL
	end
	
	local target
	local DistanceSquare = math.DistanceSquare
	local minDis = 8100000000
	for _, team in pairs(enemy_teams) do
		local member_list = team:GetMemberList() or {}
		for _, enemy in pairs(member_list) do
			if not enemy:IsDead() then
				local disSquare = DistanceSquare(self, enemy)
				if disSquare < minDis then
					minDis = disSquare
					target = enemy
				end
			end
		end
	end
	
	if target ~= nil then
		self:GetBlackBoard():Set_FightTargetId(target:Get_Uid())
		return ai.BTSTATE.SUCC
	else
		self:GetBlackBoard():SetFightTargetId(nil)
		return ai.BTSTATE.FAIL
	end
end

--敌人最密集的点
function clsRoleFighter:ProcFindDensestPoint(btNode)
	local myteam = self:GetMyTeam()
	local Pt = myteam and myteam:FindDensestPoint() or nil
	self:GetBlackBoard():SetDensestPoint(Pt)
	if Pt then 
		return ai.BTSTATE.SUCC
	else
		return ai.BTSTATE.FAIL
	end 
end

--选择施法目的点
function clsRoleFighter:ProcChooseCastPoint(btNode)
	assert(false,"尚未实现该接口")
end

-- 选择技能
function clsRoleFighter:ProcChooseSkill(btNode)
	for iSkillIndex = const.MAX_SKILL_INDEX, 1, -1 do
		if self:ProcCan2Skill(iSkillIndex)==ai.BTSTATE.SUCC and self:ProcInSkillRange(iSkillIndex)==ai.BTSTATE.SUCC then
			self:GetBlackBoard():SetSkillIndex(iSkillIndex)
			return ai.BTSTATE.SUCC
		end
	end
	
	self:GetBlackBoard():SetSkillIndex(nil)
	return ai.BTSTATE.FAIL 
end

--释放技能
function clsRoleFighter:ProcCastSkill(btNode, iSkillIndex)
	if not iSkillIndex then iSkillIndex = self:GetBlackBoard():GetSkillIndex() end
	if not iSkillIndex or self:ProcCan2Skill(iSkillIndex)==ai.BTSTATE.FAIL then return ai.BTSTATE.FAIL end
	
	local cbFinish = function(skill_id, stReason) 
		btNode:OnDealOver(self, ai.BTSTATE.SUCC)
	end
	local result = self:DoSkill(iSkillIndex, nil, cbFinish)
	
	if result then
		result = ai.BTSTATE.RUNNING
	else
		result = ai.BTSTATE.FAIL
	end
	
	return result
end

-- 逃跑
function clsRoleFighter:ProcEscape(btNode, iDistance)
	local result = false
	local cbFinish = function(stReason)
		if stReason == const.ST_REASON_COMPLETE then
			btNode:OnDealOver(self, ai.BTSTATE.SUCC)
		else
			btNode:OnDealOver(self, ai.BTSTATE.FAIL)
		end
	end
	iDistance = iDistance or 150
	local enemy = self:GetFightTarget()
	if enemy then
		local x0, y0 = enemy:getPosition()
		local x1, y1 = self:getPosition()
		local bestVector = cc.p(x1-x0, y1-y0)
		local bestAngle = math.Vector2Radian(bestVector.x, bestVector.y)
		local fixAngle = bestAngle + math.rad(math.random(-60,60))
		local fixVector = cc.p(math.Radian2Vector(fixAngle))
		local MoveVector = cc.pMul(cc.pNormalize(fixVector), iDistance)
		result = self:DoRun(x1+MoveVector.x, y1+MoveVector.y, nil, cbFinish)
	else 
		local area_list = {0,0,0,0}
		local x0, y0 = self:getPosition()
		local enemy_teams = self:GetEnemyTeamList() or {}
		for _, team in pairs(enemy_teams) do
			local member_list = team:GetMemberList() or {}
			for _, enemy in pairs(member_list) do
				if not enemy:IsDead() then
					local x1, y1 = enemy:getPosition()
					local vecX, vecY = x1-x0, y1-y0
					if vecX>=0 and vecY>=0 then
						area_list[1] = area_list[1] + 1
					end
					if vecX<=0 and vecY>=0 then
						area_list[2] = area_list[2] + 1
					end
					if vecX<=0 and vecY<=0 then
						area_list[3] = area_list[3] + 1
					end
					if vecX>=0 and vecY<=0 then
						area_list[4] = area_list[4] + 1
					end
				end
			end
		end
		local minArea = 1
		local minCnt = area_list[1]
		for i=2,4 do
			if area_list[i] < minCnt then
				minCnt = area_list[i]
				minArea = i
			end
		end
		local iAngle = math.pi/2*(minArea-1) + math.random(1,90)/90 * math.pi/2
		local dstX, dstY = x0+iDistance*math.cos(iAngle), y0+iDistance*math.sin(iAngle)
		result = self:DoRun(dstX, dstY, nil, cbFinish)
	end
	
	if result then
		result = ai.BTSTATE.RUNNING
	else 
		result = ai.BTSTATE.FAIL
	end
	
	return result
end

-- 追逐
function clsRoleFighter:ProcChase(btNode)
	local target = self:GetFightTarget()
	if not target then return ai.BTSTATE.FAIL end
	
	local times = 10 
	self:CreateTimerLoop("tmr_chase", 9, function()
		local x1, y1 = self:getPosition()
		local x2, y2 = target:getPosition()
		if (x1-x2)*(x1-x2)+(y1-y2)*(y1-y2) > 8100 then
			local dstX = x2 + math.random(90,100) * math.cos(math.random(1,360)/360*DOUBLE_PI)
			local dstY = y2 + math.random(90,100) * math.cos(math.random(1,360)/360*DOUBLE_PI)
			self:DoRun(dstX, dstY)
		else
			self:DestroyTimer("tmr_chase")
			btNode:OnDealOver(self, ai.BTSTATE.SUCC)
			return true
		end
		times = times - 1
		if times <= 0 then
			self:DestroyTimer("tmr_chase")
			btNode:OnDealOver(self, ai.BTSTATE.FAIL)
		end
	end)
	
	return ai.BTSTATE.RUNNING
end

-- 巡逻
function clsRoleFighter:ProcPatrol(btNode, iPatrolX, iPatrolY, iRange)
	local PatrolPos = self:GetBlackBoard():GetPatrolPos() or {}
	iPatrolX = iPatrolX or PatrolPos[1] or self:GetPosX()
	iPatrolY = iPatrolY or PatrolPos[2] or self:GetPosY()
	iRange = iRange or 200
	
	local dstX = iPatrolX + math.random(-iRange, iRange)
	local dstY = iPatrolY + math.random(-iRange, iRange)
	local cbFinish = function(stReason)
		if stReason == const.ST_REASON_COMPLETE then
			btNode:OnDealOver(self, ai.BTSTATE.SUCC)
		else
			btNode:OnDealOver(self, ai.BTSTATE.FAIL)
		end
	end
	local result = self:DoWalk(dstX, dstY, nil, cbFinish)
	
	if result then
		result = ai.BTSTATE.RUNNING
	else 
		result = ai.BTSTATE.FAIL
	end 
	
	return result
end

-- 前往某地
function clsRoleFighter:ProcGoTo(btNode, sType)
	local blackboard = self:GetBlackBoard()
	local destPlace = blackboard:GetDestPlace()
	local mapid, x, y, dis = destPlace.mapid, destPlace.x, destPlace.y, destPlace.dis
	
	local cbFinish = function(stReason)
		if stReason == const.ST_REASON_COMPLETE then
			btNode:OnDealOver(self, ai.BTSTATE.SUCC)
		else
			btNode:OnDealOver(self, ai.BTSTATE.FAIL)
		end
	end
	
	local result = false
	if sType == "run" then
		result = self:DoRun(x, y, dis, cbFinish)
	elseif sType == "walk" then
		result = self:DoWalk(x, y, dis, cbFinish)
	elseif sType == "rush" then
		result = self:DoRush(x, y, dis, cbFinish)
	else 
		assert(false, "参数错误: "..sType)
		result = false
	end
	
	if result then
		result = ai.BTSTATE.RUNNING
	else 
		result = ai.BTSTATE.FAIL
	end 
	
	return result
end

-- 休息
function clsRoleFighter:ProcRest(btNode, iTotalFrames)
	self:DestroyTimer("tm_ai_rest")
	local rslt = self:DoRest()
	if rslt then
		if iTotalFrames > 0 then
			self:CreateTimerDelay("tm_ai_rest", iTotalFrames, function()
				self:DestroyTimer("tm_ai_rest")
				btNode:OnDealOver(self, ai.BTSTATE.SUCC)
			end)
			return ai.BTSTATE.RUNNING
		else
			return ai.BTSTATE.SUCC
		end
	else 
		return ai.BTSTATE.FAIL
	end
end

-- 跟随
function clsRoleFighter:ProcFollowOwner(btNode, sTarget)
	local objTarget
	 
	if sTarget == "hero" then
		objTarget = ClsRoleEntityMgr.GetInstance():GetHero()
	elseif sTarget == "team_leader" then
		local target_id = self:GetMyTeam() and self:GetMyTeam():GetLeaderId()
		objTarget = ClsRoleEntityMgr:GetRole(target_id)
	elseif tonumber(sTarget) then
		local target_id = tonumber(sTarget)
		objTarget = ClsRoleEntityMgr.GetInstance():GetRole(target_id)
	elseif sTarget.GetUid and ClsRoleEntityMgr.GetInstance():GetRole(sTarget:Get_Uid()) then
		objTarget = sTarget
	end
	
	if not objTarget then 
		self:GetBlackBoard():SetFollowTargetId(nil)
		return ai.BTSTATE.FAIL 
	end
	
	self:GetBlackBoard():Set_FollowTargetId(objTarget:Get_Uid())
	return ai.BTSTATE.SUCC
end

-------------------------
-- 战斗相关
-------------------------

--碰撞
--@override
function clsRoleFighter:OnCollision(missleObj)
	if self:IsDead() then return end
	
	local HarmInfo = missleObj:GetHarmInfo()
	if not HarmInfo then return end
	
	if HarmInfo.tResults and HarmInfo.tResults[self] then
		local AffectFunc = HarmInfo.AffectFunc
		local FuncName = AffectFunc and AffectFunc.funcName
		if FuncName == "OnEcForce" then
			self:OnEcForce(missleObj, AffectFunc.param)
		elseif FuncName == "OnEcDevour" then
			self:OnEcDevour(missleObj, AffectFunc.param)
		end
	else 
		self:OnHit(missleObj, HarmInfo)
		missleObj:AfterAttack(self, HarmInfo)
	end
end

-- 受击
function clsRoleFighter:OnHit(missleObj, HarmInfo)
	local Attacker = missleObj:GetOwner()
	local Victim = self
	
	Attacker.mBuffMgr:OnBeforeAttack()
	Victim.mBuffMgr:OnBeforeHit()
	
	--计算
	local iHurtValue = 0
	local bCri = false
	if Victim:GetActState() ~= ROLE_STATE.ST_DEFEND then
		iHurtValue = (Attacker:GetPhyAtk()+Attacker:GetBuffPhyAtk()-Victim:GetPhyDef()-Victim:GetBuffPhyDef()) * HarmInfo.iDamagePower
		if Attacker:GetCriProb()+Attacker:GetBuffCriProb() >= math.random(1,100) then
			iHurtValue = iHurtValue * (Attacker:GetCriAtk()-Victim:GetCriDef())
			bCri = true
		end
		local factor = 0.01 * math.random(90,110)
		iHurtValue = iHurtValue * factor
		if iHurtValue < 0 then iHurtValue = 1 end
	end
	
	--更新血量
	local curHp = Victim:AddHP(-iHurtValue)
	logger.fight( string.format("【%d攻击%d】是否暴击: %s 掉血: %f 血量: %f",Attacker:Get_Uid(), Victim:Get_Uid(), bCri, iHurtValue, curHp) )
	
	-- 死亡判断
	if curHp <= 0 then
		Victim:Turn2ActState(ROLE_STATE.ST_DIE)
		return 
	end
	
	--
	Victim.mBuffMgr:OnAfterHit()
	Attacker.mBuffMgr:OnAfterAttack()
	
	------ 受击表现 ------
	
	-- 受击动作
	Victim:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	Victim:Turn2ActState(ROLE_STATE.ST_HIT)
	
	-- 浮空 击退 冰冻等等表现
	local AffectFunc = HarmInfo.AffectFunc
	if AffectFunc then
		Victim[AffectFunc.funcName](Victim, missleObj, AffectFunc.param)
	end
	
	--播放声音，溅血特效，掉血飘字，连击数展示
end

-- 1. 冲击力
function clsRoleFighter:OnEcImpact(missleObj, param)
	-- 受竖直方向作用力
	if param.iCZspeed > 0 then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = param.iCZspeed,
		})
	elseif self:IsInSky() and missleObj:GetOwner():IsInSky() then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = math.ceil(param.iCZspeed*0.5),
		})
	end
	
	-- 受水平方向作用力
	if param.iSPframe ~= 0 then
		local factor = self:GetActState() == ROLE_STATE.ST_SKILL and 0.3 or 1  --技能状态下效果衰减
		self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
			movDir = missleObj:GetCurDir(),
			movFrame = factor * param.iSPframe,
			movSpeed = factor * param.iSPspeed,
		})
	end
end

-- 2. 持续力
function clsRoleFighter:OnEcForce(missleObj, param)
	-- 受竖直方向作用力
	if param.iCZspeed ~= 0 and (self:GetActState()==ROLE_STATE.ST_HIT or self:GetActState()==ROLE_STATE.ST_FLIGHT) then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = param.iCZspeed,
		})
	end
	
	-- 受水平方向作用力
	if param.iSPframe ~= 0 then
		local factor = self:GetActState() == ROLE_STATE.ST_SKILL and 0.4 or 1  --技能状态下效果衰减
		self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
			movDir = missleObj:GetCurDir(),
			movFrame = 1,
			movSpeed = factor * missleObj:GetCurMoveSpeed(),
		})
	end
end

-- 3. 拖拽力
function clsRoleFighter:OnEcDrag(missleObj, param)
	self:Turn2ActState(ROLE_STATE.ST_IDLE)
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	
	local theOwner = missleObj:GetOwner()
	if not theOwner then return end
	
	local distance = param.iDistance 
	local dir = theOwner:GetCurDir()
	local x, y = theOwner:getPosition()
	self:setPosition(x+distance*math.cos(dir), y+distance*math.sin(dir))
end

-- 4. 吞噬力
function clsRoleFighter:OnEcDevour(missleObj, param)
	local iDevourH = param.iDevourH
	-- 受竖直方向作用力
	if iDevourH > 0 and self:GetPosH() < iDevourH then
		self:Turn2SkyMovState( ROLE_STATE.ST_SKYMOVLINE, {
			jmpSpeed = 3,
		})
	end
	
	-- 受水平方向作用力
	local xMissleObj, yMissleObj = missleObj:getPosition()
	local x, y = self:getPosition()
	local dX, dY = x-xMissleObj, y-yMissleObj
	local dir = math.Vector2Radian(dX,dY)
	local dis = math.sqrt((dX*dX)+(dY*dY)) * 0.95
	self:setPosition(xMissleObj+dis*math.cos(dir), yMissleObj+dis*math.sin(dir))
end

-- 5. 冻结力
function clsRoleFighter:OnEcFreeze(missleObj, param)
	-- 冻结移动
	if param.iFreezeMovTime > 0 then
		self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVFREEZE, {iFreeseTime=param.iFreezeMovTime})
		self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVFREEZE, {iFreeseTime=param.iFreezeMovTime})
	end
	-- 冻结动作
	if param.iFreezeActTime > 0 then
		self:Turn2ActState(ROLE_STATE.ST_FREEZE, {iFreeseTime=param.iFreezeActTime})
	end
end


-------------------------
-- 测试方法
-------------------------
--测试击退
function clsRoleFighter:TestHitBack()
	self:Turn2ActState(ROLE_STATE.ST_HIT)
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
		["movDir"] = (self:GetCurDir()+math.pi)%(math.pi*2),
		["movFrame"] = 5,
		["movSpeed"] = 15,
	})
end

--测试浮空
function clsRoleFighter:TestHitFloat()
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	self:Turn2ActState(ROLE_STATE.ST_FLIGHT)
	self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVLINE, {["jmpSpeed"] = const.FLIGHT_SPEED})
end

--测试冻结
function clsRoleFighter:TestFreeze()
	self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVFREEZE, {iFreeseTime=GAME_CONFIG.FPS})
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVFREEZE, {iFreeseTime=GAME_CONFIG.FPS})
	self:Turn2ActState(ROLE_STATE.ST_FREEZE, {iFreeseTime=GAME_CONFIG.FPS})
end

--测试受击
function clsRoleFighter:TestHit()
	self:Turn2ActState(ROLE_STATE.ST_HIT)
end

--测试死亡
function clsRoleFighter:TestDie()
	self:Turn2ActState(ROLE_STATE.ST_DIE)
end

--测试复活
function clsRoleFighter:TestRevive()
	self:Turn2ActState(ROLE_STATE.ST_REVIVE, {CurHP = self:GetMaxHP()})
end
