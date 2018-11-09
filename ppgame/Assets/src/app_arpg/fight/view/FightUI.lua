-------------------------
-- 大厅
-------------------------
module("ui", package.seeall)

clsFightUI = class("clsFightUI", clsBaseUI)

function clsFightUI:ctor(parent, argInfo)
	clsBaseUI.ctor(self, parent, "res/uistu/FightUI.csb")
	self:InitUiEvents()
	self:RefleshUI()
	g_EventMgr:AddListener(self, "ROUND_BEGIN", function(thisObj, Rnd)
	--	self.LblRound:setString("回合："..Rnd)
	end)
end

function clsFightUI:dtor()
	
end

function clsFightUI:RefleshUI()
	
end

function clsFightUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		fight.FightService.GetInstance():RequestExit()
	end)
end
