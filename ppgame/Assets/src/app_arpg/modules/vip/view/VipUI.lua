-------------------------
-- VIP特权页面
-------------------------
module("ui", package.seeall)

clsVipUI = class("clsVipUI", clsBaseUI)

function clsVipUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/VipUI.csb")
	self:InitUiEvents()
end

function clsVipUI:dtor()
	
end

function clsVipUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end
