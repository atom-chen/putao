-------------------------
-- 角色冲锋
-------------------------
module("smartor",package.seeall)

local default_args = {
	["atom_id"] = 1,
	["dis"] = 200,
	["iAngle"] = 0,
	["speed"] = 20,
}

local v_role_sprint = class("v_role_sprint", clsPromise)

v_role_sprint._default_args = default_args

function v_role_sprint:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "v_role_sprint"
end

function v_role_sprint:OnStop()
	KE_KillTimer(self._tmr_sprint)
	self._tmr_sprint = nil
end

function v_role_sprint:OnProc()
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
	
	local CurDir = tmpChar:GetCurDir()
	local hudu = math.rad(iAngle)
	tmpChar:SetCurDir(CurDir+hudu)
	local useFrame = math.ceil(dis/speed)
	local dx, dy = speed*math.cos(CurDir+hudu), speed*math.sin(CurDir+hudu)
	self._tmr_sprint = KE_SetInterval(1, function()
		local x,y = tmpChar:getPosition()
		tmpChar:setPosition(x+dx, y+dy)
		useFrame = useFrame - 1
		if useFrame <= 0 then
			self:Done()
			return true
		end
	end)
end

return v_role_sprint
