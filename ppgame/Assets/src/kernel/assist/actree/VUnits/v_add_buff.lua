-------------------------
-- 给角色添加BUFF
-------------------------
module("smartor",package.seeall)

local default_args = {
	["BuffType"] = 1001,
}

local v_add_buff = class("v_add_buff", clsPromise)

v_add_buff._default_args = default_args

function v_add_buff:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "v_add_buff"
end

function v_add_buff:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	self:Done()
end

return v_add_buff
