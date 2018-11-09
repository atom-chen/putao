-------------------------
-- 签到页面
-------------------------
module("ui", package.seeall)

clsSigninUI = class("clsSigninUI", clsBaseUI)

function clsSigninUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/SigninUI.csb")
	self:InitUiEvents()
end

function clsSigninUI:dtor()
	
end

function clsSigninUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end
