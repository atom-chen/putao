-------------------
-- 即时制
-------------------
module("fight", package.seeall)

clsCombatInstant = class("clsCombatInstant", clsCombat)

function clsCombatInstant:ctor()
	clsCombat.ctor(self)
end

function clsCombatInstant:InitFighterSpr()
	local TeamList = FightService.GetInstance():GetFightArgu().tTeamList
	local InstRoleEntityMgr = ClsRoleEntityMgr.GetInstance()
	local InstRoleSprMgr = ClsRoleSprMgr.GetInstance()
	
	for TeamId, RoleInfoList in pairs(TeamList) do
		for j, RoleInfo in ipairs(RoleInfoList) do
			local fighterSpr = InstRoleSprMgr:CreateRole(RoleInfo.Uid)
			fighterSpr:EnterMap(500+100*j, 500*TeamId)
			logger.fight("创建战士精灵：", TeamId, RoleInfo.Uid)
		end
	end
	
	VVDirector:BindCameraOn(InstRoleSprMgr:CreateHero())
end

function clsCombatInstant:CheckFinish()
	return self:IsTeamDie(const.COMBAT_MYSIDE) or self:IsTeamDie(const.COMBAT_OPSIDE)
end

function clsCombatInstant:Judge()
	--我方全部阵亡：则输
	if self:IsTeamDie(const.COMBAT_MYSIDE) then
		return false
	end
	--敌方全部阵亡：则赢
	if self:IsTeamDie(const.COMBAT_OPSIDE) then
		return true
	end
	--双方都未全部阵亡：血量高于敌方则赢，否则输
	return self:GetTeamHP(const.COMBAT_MYSIDE) > self:GetTeamHP(const.COMBAT_OPSIDE)
end
