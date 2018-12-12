-------------------------
-- 震屏
-------------------------
module("smartor",package.seeall)

local default_args = {
	["seconds"] = 4,
	["degree"] = 20,
}

local s_shake_screen = class("s_shake_screen", clsPromise)

s_shake_screen._default_args = default_args

function s_shake_screen:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_shake_screen"
end

function s_shake_screen:OnStop()
	if VVDirector:GetMap() then
		VVDirector:GetMap():StopShake()
	end
end

function s_shake_screen:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local seconds = args.seconds or default_args.seconds
	local degree = args.degree or default_args.degree
	
	if VVDirector:GetMap() then
		VVDirector:GetMap():Shake(seconds, degree, function()
			self:Done()
		end)
	else
		self:Done()
	end
end

return s_shake_screen
