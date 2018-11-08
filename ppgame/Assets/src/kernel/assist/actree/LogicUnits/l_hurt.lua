-------------------------
-- 给角色添加BUFF
-------------------------
module("smartor",package.seeall)

local default_args = {
	["Attacker"] = 0,
	["Victim"] = 0,
	["iDamagePower"] = 1,
}

local l_hurt = class("l_hurt", clsPromise)

l_hurt._default_args = default_args

function l_hurt:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "l_hurt"
end

function l_hurt:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local Attacker = args.Attacker
	local Victim = args.Victim
	local combatObj = fight.FightService.GetInstance():GetCombatObj()
	
	local iHurtValue = combatObj:Calculate(Attacker, Victim, args.iDamagePower)
	local curHp = Victim:AddHP(-iHurtValue)
	
	if curHp > 0 then 
		Victim:Turn2ActState(ROLE_STATE.ST_HIT) 
	elseif combatObj:_TryFinish() then
		logger.fight("战斗结束，停止Drama")
		Attacker:BreakSkill()
	end
	
	self:Done()
end

return l_hurt
