-------------------------
-- 黑屏
-------------------------
module("smartor",package.seeall)

local default_args = {
	["iBlackScreen"] = 1,
	["iKeepSeconds"] = 1,
}

local s_black_screen = class("s_black_screen", clsPromise)

s_black_screen._default_args = default_args

function s_black_screen:ctor(argInfo, Ctx)
	clsPromise.ctor(self, argInfo, Ctx)
	self._node_type = "s_black_screen"
end

function s_black_screen:OnStop()
	KE_KillTimer(self._timer)
	self._timer = nil
	ClsLayerManager.GetInstance():ShowAllLayer(true)
end

function s_black_screen:OnProc()
	local args = self:GetArgInfo()
	local xCtx = self:GetContext()
	local iBlackScreen = tonumber(args.iBlackScreen) or 1
	local iKeepSeconds = tonumber(args.iKeepSeconds) or 1
	
	local bBlack = iBlackScreen == 1
	ClsLayerManager.GetInstance():ShowAllLayer(not bBlack)
	
	self._timer = KE_SetAbsTimeout(iKeepSeconds, function()
		ClsLayerManager.GetInstance():ShowAllLayer(bBlack)
		self._timer = nil
		self:Done()
	end)
end

return s_black_screen
