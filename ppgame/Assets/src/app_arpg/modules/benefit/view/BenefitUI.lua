-------------------------
-- 救济金页面
-------------------------
module("ui", package.seeall)

clsBenefitUI = class("clsBenefitUI", clsBaseUI)

function clsBenefitUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/BenefitUI.csb")
	self:InitUiEvents()
end

function clsBenefitUI:dtor()
	
end

function clsBenefitUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end
