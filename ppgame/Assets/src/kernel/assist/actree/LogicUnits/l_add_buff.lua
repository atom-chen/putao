-------------------------
-- 给角色添加BUFF
-------------------------
module("smartor",package.seeall)

local default_args = {
	["BuffType"] = 1001,
}

local l_add_buff = class("l_add_buff", clsPromise)

l_add_buff._default_args = default_args

function l_add_buff:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "l_add_buff"
end

function l_add_buff:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local BuffType = args.BuffType
	local Placer = args.Placer
	local Victim = args.Victim
	Victim:GetBuffMgr():AddBuff(Placer, BuffType)
	self:Done()
end

return l_add_buff
