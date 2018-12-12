-------------------------
-- 设置角色朝向
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["iAngle"] = 0,
}

local s_role_set_dir = class("s_role_set_dir", clsPromise)

s_role_set_dir._default_args = default_args

function s_role_set_dir:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_role_set_dir"
end

function s_role_set_dir:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local iAngle = args.iAngle
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	tmpChar:SetCurDir(math.rad(iAngle))
	self:Done()
end

return s_role_set_dir
