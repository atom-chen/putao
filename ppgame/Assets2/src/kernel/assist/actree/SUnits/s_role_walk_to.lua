-------------------------
-- 角色走到某点
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["sx"] = 0,
	["sy"] = 0,
	["dx"] = 0,
	["dy"] = 0,
	["distance"] = 10,
	["speed"] = 7,
}

local s_role_walk_to = class("s_role_walk_to", clsPromise)

s_role_walk_to._default_args = default_args

function s_role_walk_to:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_role_walk_to"
end

function s_role_walk_to:OnStop()
	local atom_id = self:GetArgInfo().atom_id
	local role = self:GetContext():GetAtom(atom_id)
	if role then role:DoRest() end
end

function s_role_walk_to:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local sx = args.sx
	local sy = args.sy
	local dx = args.dx
	local dy = args.dy
	local distance = args.distance or default_args.distance
	local speed = args.speed
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	tmpChar:DoWalk(dx, dy, distance, function()
		self:Done()
	end)
end

return s_role_walk_to
