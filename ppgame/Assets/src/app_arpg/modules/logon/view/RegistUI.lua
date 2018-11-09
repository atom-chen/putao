-------------------------
-- 注册页面
-------------------------
module("ui", package.seeall)

clsRegistArpgUI = class("clsRegistArpgUI", clsBaseUI)

function clsRegistArpgUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/RegistUI.csb")
	self:InitUiEvents()
end

function clsRegistArpgUI:dtor()
	
end

function clsRegistArpgUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		KE_SafeDelete(self)
	end)
	--注册
	utils.RegClickEvent(self.BtnRegist, function()
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
		KBEngine.app:createAccount(username, password, "app_q1")
	end)
	--获取注册码
	utils.RegClickEvent(self.BtnAskCode, function()
		utils.TellMe("尚未实现")
	end)
end
