-------------------------
-- 角色冒泡说话
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["words"] = "不要逼我骂你！",
}

local s_pop_say = class("s_pop_say", clsPromise)

s_pop_say._default_args = default_args

function s_pop_say:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_pop_say"
end

function s_pop_say:OnStop()
	local atom_id = self:GetArgInfo().atom_id
	local target = self:GetContext():GetAtom(atom_id)
	if target then target:StopSay() end
end

function s_pop_say:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local sWords = args.words or default_args.words
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	tmpChar:DoSay(sWords, function()
		self:Done()
	end)
end

return s_pop_say
