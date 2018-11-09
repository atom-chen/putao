-------------------------
-- 大厅
-------------------------
module("ui", package.seeall)

clsMainUI = class("clsMainUI", clsBaseUI)

function clsMainUI:ctor(parent, argInfo)
	clsBaseUI.ctor(self, parent, "res/uistu/MainUI.csb")
	self:InitUiEvents()
	self:RefleshUI()
end

function clsMainUI:dtor()
	
end

function clsMainUI:RefleshUI()
	local heroId = ClsEntityMgr.GetInstance():GetHeroId()
	local entityObj = ClsEntityMgr.GetInstance():GetEntity(heroId)
	self.LblMyName:setString(entityObj and entityObj:GetNickName() or "")
	self.HeadWnd:SetHeadUid(heroId)
	self.HeadWnd:EnableTouch(function()
		ClsUIManager.GetInstance():ShowPanel("clsPersonalUI")
	end)
	self.lblCoin:setString("0")
	self.lblDiamond:setString(entityObj and entityObj:GetdiamondNum() or 0)
end

function clsMainUI:InitUiEvents()
	self.ListBottom:setScrollBarEnabled(false)
	
	--金币
	self.coinBg:setTouchEnabled(true)
	utils.RegClickEvent(self.coinBg, function()
		ClsUIManager.GetInstance():ShowPanel("clsShopUI"):ShowPage(const.CURRENCY.GOLD)
	end)
	--钻石
	self.diamondBg:setTouchEnabled(true)
	utils.RegClickEvent(self.diamondBg, function()
		ClsUIManager.GetInstance():ShowPanel("clsShopUI"):ShowPage(const.CURRENCY.DIAMOND)
	end)
	
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
	
	--救济金
	utils.RegClickEvent(self.BtnBenefit, function()
		ClsUIManager.GetInstance():ShowPopWnd("clsBenefitUI")
	end)
	--转盘
	utils.RegClickEvent(self.BtnWheel, function()
		ClsUIManager.GetInstance():ShowDialog("clsWheelUI")
	end)
	--摇钱树
	utils.RegClickEvent(self.BtnMoneyTree, function()
		
	end)
	--首充
	utils.RegClickEvent(self.BtnFirstRecharge, function()
		ClsUIManager.GetInstance():ShowDialog("clsFirstRechargeUI")
	end)
	--每日任务
	utils.RegClickEvent(self.BtnDailyTask, function()
		ClsUIManager.GetInstance():ShowPanel("clsTaskUI")
	end)
	--活动
	utils.RegClickEvent(self.BtnActivity, function()
		
	end)
	--签到
	utils.RegClickEvent(self.BtnSignin, function()
		ClsUIManager.GetInstance():ShowPopWnd("clsSigninUI")
	end)
end
