-------------------------
-- 账号登录页面
-------------------------
module("ui", package.seeall)

clsLoginByAccountUI = class("clsLoginByAccountUI", clsBaseUI)

function clsLoginByAccountUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/LoginByAccountUI.csb")
	self:InitUiEvents()
end

function clsLoginByAccountUI:dtor()
	
end

function clsLoginByAccountUI:InitUiEvents()
	--进入
	utils.RegClickEvent(self.BtnEnter, function()
		local username = self.EditPhone:getString()
		local password = self.EditSecret:getString()
		if not username or utils.IsWhiteSpace(username) then
			utils.TellMe("请输入有效的用户名")
			return
		end 
		if not username or utils.IsWhiteSpace(password) then
			utils.TellMe("请输入有效的密码")
			return
		end 
		KBEngine.app:login(username, password, "app_q1")
	end)
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		KE_SafeDelete(self)
	end)
end
