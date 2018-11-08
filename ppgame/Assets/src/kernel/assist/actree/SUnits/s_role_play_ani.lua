-------------------------
-- 角色播放动作
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["ani_name"] = "skill_0_1",
	["loop_times"] = 1,
	["speed_scale"] = 1,
}

local s_role_play_ani = class("s_role_play_ani", clsPromise)

s_role_play_ani._default_args = default_args

function s_role_play_ani:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_role_play_ani"
end

function s_role_play_ani:OnStop()
	self.on_ani_over = nil
end

function s_role_play_ani:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local ani_name = args.ani_name
	local loop_times = args.loop_times or 1
	local speed_scale = args.speed_scale or 1
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	self.on_ani_over = function(this) this:Done() end
	local bSucc = tmpChar:PlayAni(ani_name, loop_times, function(flag) 
		if self.on_ani_over then self:on_ani_over() end 
	end)
	if not bSucc then self:Done() end 
end

return s_role_play_ani
