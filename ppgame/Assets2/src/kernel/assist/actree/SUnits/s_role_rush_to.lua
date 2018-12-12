-------------------------
-- 角色冲刺
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["dx"] = 0,
	["dy"] = 0,
	["distance"] = 0,
	["speed"] = 20,
}

local s_role_rush_to = class("s_role_rush_to", clsPromise)

s_role_rush_to._default_args = default_args

function s_role_rush_to:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_role_rush_to"
end

function s_role_rush_to:OnStop()
	local atom_id = self:GetArgInfo().atom_id
	local role = self:GetContext():GetAtom(atom_id)
	if role then role:DoRest() end
end

function s_role_rush_to:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local dx = args.dx
	local dy = args.dy
	local distance = args.distance or 0
	local speed = args.speed or 20
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	tmpChar:DoRush(dx, dy, distance, function(stReason)
		self:Done()
	end)
end

return s_role_rush_to
