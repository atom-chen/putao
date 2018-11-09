-------------------------
-- 登录界面
-------------------------
module("ui", package.seeall)

clsLoginArpgUI = class("clsLoginArpgUI", clsBaseUI)

function clsLoginArpgUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/LoginUI.csb")
	self:InitUiEvents()
	
	local testImg = ccui.ImageView:create()
	testImg:SetCircle(true)
	self:addChild(testImg)
	testImg:LoadTextureSync("http://q.qlogo.cn/qqapp/101409330/78DF07887B838C2D9A7D951FFB98861A/40")
	testImg:setPosition(60,660)
	
--	KE_SetTimeout(45,function() test.testPromise1() end)
end

function clsLoginArpgUI:dtor()
	
end

function clsLoginArpgUI:InitUiEvents()
	--QQ登录
	utils.RegClickEvent(self.BtnQQLogon, function()
		local username = "SSSSSS"
		local password = "ssssssss"
		if GAME_CONFIG.VV_OFFLINE_MODE then
			VVDirector:GetStateMachine():ToStateGameing()
		else
			KBEngine.app:login(username,password, "app_q1")
		end
	end)
	--微信登录
	utils.RegClickEvent(self.BtnWXLogon, function()
		local username = "SSSSSS2"
		local password = "ssssssss"
		if GAME_CONFIG.VV_OFFLINE_MODE then
			VVDirector:GetStateMachine():ToStateGameing()
		else
			KBEngine.app:login(username,password, "app_q1")
		end
	end)
	--登录
	utils.RegClickEvent(self.BtnLogin, function()
		ClsUIManager.GetInstance():ShowPanel("clsLoginByAccountUI")
	end)
	--注册
	utils.RegClickEvent(self.BtnRegist, function()
		ClsUIManager.GetInstance():ShowPanel("clsRegistUI")
	end)
end
