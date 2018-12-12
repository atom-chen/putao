-------------------------
-- 移动摄像机
-------------------------
module("smartor",package.seeall)

local default_args = {
	["dstX"] = 555,
	["dstY"] = 555,
	["speed"] = 12,
}

local s_move_camera = class("s_move_camera", clsPromise)

s_move_camera._default_args = default_args

function s_move_camera:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_move_camera"
end

function s_move_camera:OnStop()
	KE_KillTimer(self._mTimer)
end

function s_move_camera:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local dstX = args.dstX
	local dstY = args.dstY
	local speed = args.speed
	
	if not VVDirector:GetMap() then
		return self:Done()
	end
	
	local curX, curY = VVDirector:GetMap():GetCameraPos()
	local iDir = math.Vector2Radian(dstX-curX, dstY-curY)
	local pathline = utils.FindPath(curX, curY, dstX, dstY)
	
	self._mTimer = KE_SetInterval(1, function()
		local x,y,dir,isEnd = pathline.get_next(5)
		if isEnd then
			KE_KillTimer(self._mTimer)
			self:Done()
			return true
		else
			VVDirector:GetMap():SetCameraPos(x,y)
		end
	end)
end

return s_move_camera
