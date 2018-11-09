-------------------------
-- 大厅
-------------------------
module("ui", package.seeall)

clsMainUI = class("clsMainUI", clsBaseUI)

function clsMainUI:ctor(parent, argInfo)
	clsBaseUI.ctor(self, parent)
	self:InitUiEvents()
	self:RefleshUI()
end

function clsMainUI:dtor()
	
end

function clsMainUI:RefleshUI()
	
end

function clsMainUI:InitUiEvents()
	--[[
	--即时战斗
	utils.RegClickEvent(self.BtnInstant, function()
		local FightInfo = fight.clsFightArgu.new(const.COMBAT_TYPE.Instant)
		fight.FightService.GetInstance():EnterFight(FightInfo)
	end)
	--回合战斗
	utils.RegClickEvent(self.BtnRound, function()
		local FightInfo = fight.clsFightArgu.new(const.COMBAT_TYPE.Round)
		fight.FightService.GetInstance():EnterFight(FightInfo)
	end)
	--站桩战斗
	utils.RegClickEvent(self.BtnPost, function()
		local FightInfo = fight.clsFightArgu.new(const.COMBAT_TYPE.Post)
		fight.FightService.GetInstance():EnterFight(FightInfo)
	end)
	]]
end
