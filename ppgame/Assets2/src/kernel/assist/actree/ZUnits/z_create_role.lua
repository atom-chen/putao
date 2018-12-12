-------------------------
-- 创建角色
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["TypeId"] = 10001,
	["iShapeId"] = 32000,
	["x"] = 110,
	["y"] = 110,
}

local z_create_role = class("z_create_role", clsPromise)

z_create_role._default_args = default_args

function z_create_role:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "z_create_role"
end

function z_create_role:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local atom_id = args.atom_id 
--	local iShapeId = args.iShapeId or default_args.iShapeId
	local TypeId = args.TypeId or default_args.TypeId
	local x = args.x or default_args.x
	local y = args.y or default_args.y
	
	xCtx:CreateXRole(atom_id, TypeId)
	
	local tmpChar = xCtx:GetAtom(atom_id)
	if not tmpChar then
		logger.error("====ERROR: 创建角色失败", atom_id, self._node_type)
		return self:Done()
	end
	
	if args.iShapeId then tmpChar:SetShapeId(args.iShapeId) end
	tmpChar:EnterMap(x, y)
	self:Done()
end

return z_create_role
