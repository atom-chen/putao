-------------------------
-- 播放角色技能
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["skill_index"] = 1,
	["times"] = 1,
}

local s_play_skill = class("s_play_skill", clsPromise)

s_play_skill._default_args = default_args

function s_play_skill:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_play_skill"
end

function s_play_skill:OnStop()
	local atom_id = self:GetArgInfo().atom_id
	local target = self:GetContext():GetAtom(atom_id)
	if target then
		target:BreakSkill()
	end
end

function s_play_skill:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local skill_index = args.skill_index or default_args.skill_index
	local times = args.times or default_args.times
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	if not tmpChar:DoSkill(skill_index, nil, function(skill_id, stReason) self:Done() end) then
		self:Done()
	end
end

return s_play_skill
