-------------------------
-- 商城页面
-------------------------
module("ui", package.seeall)

clsShopUI = class("clsShopUI", clsBaseUI)

function clsShopUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/ShopUI.csb")
	self.ListViewGold:setItemModel(self.ListItemGold)
	self.ListViewDiamond:setItemModel(self.ListItemDiamond)
	for i=1,10 do 
		self.ListViewGold:pushBackDefaultItem()
		self.ListViewDiamond:pushBackDefaultItem()
	end
	self:ShowPage(const.CURRENCY.DIAMOND)
	self:InitUiEvents()
end

function clsShopUI:dtor()
	
end

function clsShopUI:InitUiEvents()
	--金币标签
	utils.RegClickEvent(self.tabDiamond, function()
		self:ShowPage(const.CURRENCY.DIAMOND)
	end)
	--钻石标签
	utils.RegClickEvent(self.tabGold, function()
		self:ShowPage(const.CURRENCY.GOLD)
	end)
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end

function clsShopUI:ShowPage(idx)
	self.tabGold:setEnabled(idx~=const.CURRENCY.GOLD)
	self.tabDiamond:setEnabled(idx~=const.CURRENCY.DIAMOND)
	self.ListViewDiamond:setVisible(idx==const.CURRENCY.DIAMOND)
	self.ListViewGold:setVisible(idx==const.CURRENCY.GOLD)
end
