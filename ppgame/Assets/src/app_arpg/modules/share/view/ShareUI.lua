-------------------------
-- 分享页面
-------------------------
module("ui", package.seeall)

clsShareUI = class("clsShareUI", clsBaseUI)

function clsShareUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/ShareUI.csb")
	self:InitUiEvents()
end

function clsShareUI:dtor()
	
end

function clsShareUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end
