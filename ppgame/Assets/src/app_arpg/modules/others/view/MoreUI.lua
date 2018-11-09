-------------------------
-- 更多
-------------------------
module("ui", package.seeall)

clsMoreUI = class("clsMoreUI", clsBaseUI)

function clsMoreUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/MoreUI.csb")
	self:InitUiEvents()
end

function clsMoreUI:dtor()
	
end

function clsMoreUI:InitUiEvents()
	--进入官网
	utils.RegClickEvent(self.BtnWebsite, function()
		cc.Application:getInstance():openURL("https://xiangames.com/land.html")
	end)
	--关于我们
	utils.RegClickEvent(self.BtnAbout, function()
		
	end)
	--联系客服
	utils.RegClickEvent(self.BtnKefu, function()
		
	end)
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
	--充值购买
	utils.RegClickEvent(self.BtnRecharge, function()
		ClsUIManager.GetInstance():ShowPanel("clsShopUI"):ShowPage(const.CURRENCY.DIAMOND)
	end)
	--收货地址
	utils.RegClickEvent(self.BtnInfomation, function()
		
	end)
	--好礼兑换
	utils.RegClickEvent(self.BtnGift, function()
		
	end)
	--系统设置
	utils.RegClickEvent(self.BtnSysset, function()
		
	end)
	--退出登录
	utils.RegClickEvent(self.BtnRelogin, function()
		ClsStateMachine:GetInstance():ReLogin()
	end)
end
