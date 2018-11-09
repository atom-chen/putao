-------------------
-- 半即时制
-------------------
module("fight", package.seeall)

clsCombatPost = class("clsCombatPost", clsCombat)

function clsCombatPost:ctor()
	clsCombat.ctor(self)
end

function clsCombatPost:Calculate(Attacker, Victim, iDamagePower)
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

function clsCombatPost:InitFighterSpr()
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

function clsCombatPost:CheckFinish()
	return self:IsTeamDie(const.COMBAT_MYSIDE) or self:IsTeamDie(const.COMBAT_OPSIDE)
end

function clsCombatPost:Judge()
	--我方全部阵亡：则输
	if self:IsTeamDie(const.COMBAT_MYSIDE) then
		return false
	end
	--敌方全部阵亡：则赢
	if self:IsTeamDie(const.COMBAT_OPSIDE) then
		return true
	end
end
