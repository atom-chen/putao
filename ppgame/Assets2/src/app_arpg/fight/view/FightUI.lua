-------------------------
-- 大厅
-------------------------
module("ui", package.seeall)

clsFightUI = class("clsFightUI", clsBaseUI)

function clsFightUI:ctor(parent, argInfo)
	clsBaseUI.ctor(self, parent)
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
	self.BtnClose = ccui.Button:create("", "", "")
	self.BtnClose:setScale9Enabled(true)
	self.BtnClose:setContentSize(120, 72)
	self.BtnClose:setTitleText("退出战斗")
	self.BtnClose:setPosition(660, 36)
	self:addChild(self.BtnClose)
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		fight.FightService.GetInstance():RequestExit()
	end)
end
