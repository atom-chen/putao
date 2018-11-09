-------------------
-- 回合制
-------------------
module("fight", package.seeall)

clsCombatRound = class("clsCombatRound", clsCombat)

function clsCombatRound:ctor()
	clsCombat.ctor(self)
	self._curRound = 0
end

function clsCombatRound:GetCurRound() return self._curRound end 

-----------------------------------------------------------------

function clsCombatRound:Calculate(Attacker, Victim, iDamagePower)
	Attacker.mBuffMgr:OnBeforeAttack()
	Victim.mBuffMgr:OnBeforeHit()
	
	--计算
	local iHurtValue = 0
	local bCri = false
	if Victim:GetActState() ~= ROLE_STATE.ST_DEFEND then
		iHurtValue = (Attacker:GetPhyAtk()+Attacker:GetBuffPhyAtk()-Victim:GetPhyDef()-Victim:GetBuffPhyDef()) * iDamagePower
		if Attacker:GetCriProb()+Attacker:GetBuffCriProb() >= math.random(1,100) then
			iHurtValue = iHurtValue * (Attacker:GetCriAtk()-Victim:GetCriDef())
			bCri = true
		end
		local factor = 0.01 * math.random(90,110)
		iHurtValue = iHurtValue * factor
		if iHurtValue < 0 then iHurtValue = 1 end
	end
	
	--
	if Victim:GetCurHP()-iHurtValue > 0 then
		Victim.mBuffMgr:OnAfterHit()
		Attacker.mBuffMgr:OnAfterAttack()
	end
	
	iHurtValue = Victim.mBuffMgr:OnFixHurtValue(Attacker, iHurtValue)
	
	logger.fight(string.format("【%d攻击%d】总伤害：%f  是否暴击：%s",Attacker:Get_Uid(),Victim:Get_Uid(),iHurtValue,bCri))
	return iHurtValue
end 

function clsCombatRound:CallAttack(memberList)
	local retAni = smartor.clsPromise.new()
	
	for _, Attacker in ipairs(memberList) do 
		if self:_TryFinish() then break end
		local attackAni = smartor.clsPromise.new()
		attackAni:SetProcFunc(function(thisObj,pms,Attacker)
			if self:_TryFinish() then 
				pms:Done()
			else 
				local chooseIdx = 5
				for i = 5, 1, -1 do 
					if Attacker:ProcCan2Skill(i) == ai.BTSTATE.SUCC then 
						chooseIdx = i 
						break
					end 
				end 
				local bSucc = Attacker:DoSkill(chooseIdx, nil, function() 
					pms:Done() 
				end)
				if not bSucc then pms:Done() end 
			end 
		end, self, Attacker)
		
		retAni:SetNext(attackAni)
	end
	
	return retAni
end 

-----------------------------------------------------------------
function clsCombatRound:StartCombat()
	clsCombat.StartCombat(self)
	self:StepRoundBegin()
end

function clsCombatRound:StepRoundBegin()
	if self:_TryFinish() then return end 
	self._curRound = self._curRound + 1
	logger.fight("---------新回合开始", self._curRound)
	g_EventMgr:FireEvent("ROUND_BEGIN", self._curRound)
	
	self:CreateAbsTimerDelay("StepRoundBeginTmr", 0.2, function()
		self:StepMySideAttack()
	end)
end

function clsCombatRound:StepMySideAttack()
	if self:_TryFinish() then return end 
	
	local memberList = self.mTeamMgr:GetGroup(const.COMBAT_MYSIDE):GetMemberList()
	logger.fight("---------我方攻击阶段 "..self._curRound.."  "..#memberList)
	
	local retAni = self:CallAttack(memberList)
	
	local fani = smartor.clsPromise.new()
	fani:SetNext(retAni)
	fani:SetNext( smartor.NewUnit("x_delay_frame", {frames=15}) )
	fani:NextCall(function(thisObj, pms)
		pms:Done()
		self:StepOpSideAttack()
	end)
	fani:Run()
end

function clsCombatRound:StepOpSideAttack()
	if self:_TryFinish() then return end 
	
	local memberList = self.mTeamMgr:GetGroup(const.COMBAT_OPSIDE):GetMemberList()
	logger.fight("---------敌方攻击阶段 "..self._curRound.."  "..#memberList)
	
	local retAni = self:CallAttack(memberList)
	
	local fani = smartor.clsPromise.new()
	fani:SetNext(retAni)
	fani:SetNext( smartor.NewUnit("x_delay_frame", {frames=5}) )
	fani:NextCall(function(thisObj, pms)
		pms:Done()
		self:StepRoundEnd()
	end)
	fani:Run()
end

function clsCombatRound:StepRoundEnd()
	logger.fight("---------回合结束", self._curRound)
	g_EventMgr:FireEvent("ROUND_END", self._curRound)
	if self:_TryFinish() then return end 
	
	self:CreateAbsTimerDelay("StepRoundEndTmr", 0.2, function()
		self:StepRoundBegin()
	end)
end

-----------------------------------------------------------------

function clsCombatRound:InitFighterSpr()
	local instFight = fight.FightService.GetInstance()
	local xMid = instFight:GetXMid()
	local yMid = instFight:GetYMid()
	local DIS = instFight:GetDis()
	local SPACE = instFight:GetSpace()
	
	local TeamList = FightService.GetInstance():GetFightArgu().tTeamList
	local InstRoleEntityMgr = ClsRoleEntityMgr.GetInstance()
	local InstRoleSprMgr = ClsRoleSprMgr.GetInstance()
	
	for j, RoleInfo in ipairs(TeamList[const.COMBAT_MYSIDE]) do
		local fighterSpr = InstRoleSprMgr:CreateRole(RoleInfo.Uid)
		fighterSpr:EnterMap(xMid-DIS-SPACE*(j-1), yMid)
		logger.fight("创建我方精灵：", RoleInfo.Uid, xMid-DIS-SPACE*(j-1), yMid)
		fighterSpr:FaceTo(xMid,yMid)
	end
	
	for j, RoleInfo in ipairs(TeamList[const.COMBAT_OPSIDE]) do
		local fighterSpr = InstRoleSprMgr:CreateRole(RoleInfo.Uid)
		fighterSpr:EnterMap(xMid+DIS+SPACE*(j-1), yMid)
		logger.fight("创建敌方精灵：", RoleInfo.Uid, xMid+DIS+SPACE*(j-1), yMid)
		fighterSpr:FaceTo(xMid,yMid)
	end
	
	VVDirector:GetMap():LockCamera()
	VVDirector:GetMap():SetCameraPos(xMid,yMid+100)
end

function clsCombatRound:CheckFinish()
	return self:IsTeamDie(const.COMBAT_MYSIDE) or self:IsTeamDie(const.COMBAT_OPSIDE)
end

function clsCombatRound:Judge()
	--我方全部阵亡：则输
	if self:IsTeamDie(const.COMBAT_MYSIDE) then
		return false
	end
	--敌方全部阵亡：则赢
	if self:IsTeamDie(const.COMBAT_OPSIDE) then
		return true
	end
end
