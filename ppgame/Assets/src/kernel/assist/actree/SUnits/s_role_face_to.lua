-------------------------
-- 角色面向某点
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["dx"] = 0,
	["dy"] = 0,
}

local s_role_face_to = class("s_role_face_to", clsPromise)

s_role_face_to._default_args = default_args

function s_role_face_to:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_role_face_to"
end

function s_role_face_to:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id
	local dx = args.dx
	local dy = args.dy
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 不存在该角色", atom_id, self._node_type)
		return self:Done()
	end
	
	tmpChar:FaceTo(dx, dy)
	self:Done()
end

return s_role_face_to
