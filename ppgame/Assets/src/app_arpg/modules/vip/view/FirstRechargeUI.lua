-------------------------
-- 首充页面
-------------------------
module("ui", package.seeall)

clsFirstRechargeUI = class("clsFirstRechargeUI", clsBaseUI)

function clsFirstRechargeUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/FirstRechargeUI.csb")
	self:InitUiEvents()
end

function clsFirstRechargeUI:dtor()
	
end

function clsFirstRechargeUI:InitUiEvents()
	--立即充值
	utils.RegClickEvent(self.BtnRecharge, function()
		KE_SafeDelete(self)
		ClsUIManager.GetInstance():ShowPanel("clsShopUI"):ShowPage(const.CURRENCY.DIAMOND)
	end)
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end
