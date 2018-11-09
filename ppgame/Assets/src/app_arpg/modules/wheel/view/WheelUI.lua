-------------------------
-- 轮盘页面
-------------------------
module("ui", package.seeall)

clsWheelUI = class("clsWheelUI", clsBaseUI)

function clsWheelUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/WheelUI.csb")
	self:InitUiEvents()
end

function clsWheelUI:dtor()
	
end

function clsWheelUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
	--转动按钮
	utils.RegClickEvent(self.BtnWheel, function()
		
	end)
end
