-------------------------
-- 角色冲刺
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["dis"] = 200,
	["iAngle"] = 0,
	["speed"] = 20,
}

local s_role_rush_by = class("s_role_rush_by", clsPromise)

s_role_rush_by._default_args = default_args

function s_role_rush_by:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_role_rush_by"
end

function s_role_rush_by:OnStop()
	local atom_id = self:GetArgInfo().atom_id
	local role = self:GetContext():GetAtom(atom_id)
	if role then role:DoRest() end
end

function s_role_rush_by:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local dis = args.dis
	local iAngle = args.iAngle
	local speed = args.speed
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	local x,y = tmpChar:getPosition()
	local CurDir = tmpChar:GetCurDir()
	local hudu = math.rad(iAngle)
	local dx, dy = x+dis*math.cos(CurDir+hudu), y+dis*math.sin(CurDir+hudu)
	tmpChar:DoRush(dx, dy, 0, function(stReason)
		self:Done()
	end)
end

return s_role_rush_by
