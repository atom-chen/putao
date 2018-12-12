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
	self.BtnInstant = ccui.Button:create("", "", "")
	self.BtnInstant:setScale9Enabled(true)
	self.BtnInstant:setContentSize(120, 72)
	self.BtnInstant:setTitleText("即时战斗")
	self.BtnInstant:setPosition(200, 36)
	self:addChild(self.BtnInstant)
	
	self.BtnRound = ccui.Button:create("", "", "")
	self.BtnRound:setScale9Enabled(true)
	self.BtnRound:setContentSize(120, 72)
	self.BtnRound:setTitleText("回合战斗")
	self.BtnRound:setPosition(330, 36)
	self:addChild(self.BtnRound)
	
	self.BtnPost = ccui.Button:create("", "", "")
	self.BtnPost:setScale9Enabled(true)
	self.BtnPost:setContentSize(120, 72)
	self.BtnPost:setTitleText("站桩战斗")
	self.BtnPost:setPosition(460, 36)
	self:addChild(self.BtnPost)
	
	--即时战斗
	utils.RegClickEvent(self.BtnInstant, function()
		local fightArgu = fight.clsFightArgu.new(const.COMBAT_TYPE.Instant)
		local soldier1 = { Uid=1, TypeId=10001 }
		local soldier2 = { Uid=2, TypeId=10002 }
		local soldier3 = { Uid=3, TypeId=10002 }
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier1)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier2)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier3)
		local soldier4 = { Uid=4, TypeId=10001 }
		local soldier5 = { Uid=5, TypeId=10002 }
		local soldier6 = { Uid=6, TypeId=10002 }
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier4)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier5)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier6)
		fight.FightService.GetInstance():EnterFight(fightArgu)
	end)
	--回合战斗
	utils.RegClickEvent(self.BtnRound, function()
		local fightArgu = fight.clsFightArgu.new(const.COMBAT_TYPE.Round)
		local soldier1 = { Uid=1, TypeId=10001 }
		local soldier2 = { Uid=2, TypeId=10002 }
		local soldier3 = { Uid=3, TypeId=10002 }
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier1)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier2)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier3)
		local soldier4 = { Uid=4, TypeId=10001 }
		local soldier5 = { Uid=5, TypeId=10002 }
		local soldier6 = { Uid=6, TypeId=10002 }
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier4)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier5)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier6)
		fight.FightService.GetInstance():EnterFight(fightArgu)
	end)
	--站桩战斗
	utils.RegClickEvent(self.BtnPost, function()
		local fightArgu = fight.clsFightArgu.new(const.COMBAT_TYPE.Post)
		local soldier1 = { Uid=1, TypeId=10001 }
		local soldier2 = { Uid=2, TypeId=10002 }
		local soldier3 = { Uid=3, TypeId=10002 }
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier1)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier2)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier3)
		local soldier4 = { Uid=4, TypeId=10001 }
		local soldier5 = { Uid=5, TypeId=10002 }
		local soldier6 = { Uid=6, TypeId=10002 }
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier4)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier5)
		ClsRoleEntityMgr.GetInstance():UpdateFighter(soldier6)
		fight.FightService.GetInstance():EnterFight(fightArgu)
	end)
end
