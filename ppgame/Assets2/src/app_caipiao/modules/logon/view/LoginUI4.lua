-------------------------
-- 登录界面
-------------------------
module("ui", package.seeall)

local crypto = require("kernel.framework.crypto")

clsLoginUI4 = class("clsLoginUI4", clsBaseUI)

function clsLoginUI4:ctor(parent)
	clsBaseUI.ctor(self, parent, "uistu/LoginUI4.csb")
	
	--self.PanelRed:setContentSize(self.PanelRed:getContentSize().width, self.AreaAuto:getContentSize().height/2-45)
	
	self.EditLogonUsername = utils.ReplaceTextField(self.EditLogonUsername,"uistu/common/null.png","FF111111")
	self.EditLogonPassword = utils.ReplaceTextField(self.EditLogonPassword,"uistu/common/null.png","FF111111")
	self.EditLogonYzm = utils.ReplaceTextField(self.EditLogonYzm,"uistu/common/null.png","FF111111")
	
	self.EditLogonUsername:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
	self.EditLogonPassword:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
	self.EditLogonYzm:setInputMode(cc.EDITBOX_INPUT_MODE_SINGLELINE)
	
	self:AdjustUI()

	self.EditLogonPassword:SetSensitive(true)
	self.BtnEyePwd:getChildByName("eyesee"):setVisible(not self.EditLogonPassword:IsSensitive())
    self.BtnEyePwd:getChildByName("eyeclose"):setVisible(self.EditLogonPassword:IsSensitive())
	
	self:InitUiEvents()
	self:InitGlbEvents()
	
--	local info = ClsLoginMgr.GetInstance():GetInputLoginInfo()
--	self.EditLogonUsername:setString(info.username)
--	self.EditLogonPassword:setString(info.pwd)
	proto.req_get_ipinfo()
	ClsLoginMgr.GetInstance():req_home_sysinfo()
end

function clsLoginUI4:dtor()
	
end

function clsLoginUI4:InitUiEvents()
	utils.RegClickEvent(self.BtnClose, function() self:removeSelf() end)
	--注册
	utils.RegClickEvent(self.BtnHitRegist, function()
		self:removeSelf()
		ClsUIManager.GetInstance():ShowPopWnd("clsRegistUI2")
	end)
	--登录
	utils.RegClickEvent(self.BtnLogon, function()
		if utils.IsWhiteSpace(self.EditLogonPassword:getString()) then
            utils.TellMe("密码不可为空!")
        else
		    ClsLoginMgr.GetInstance():req_login_logon(self.EditLogonUsername:getString(), self.EditLogonPassword:getString(), self.EditLogonYzm:getString())
        end
	end)
    utils.RegClickEvent(self.BtnEyePwd,function()
        self.EditLogonPassword:ToggleSensitive()
        self.BtnEyePwd:getChildByName("eyesee"):setVisible(not self.EditLogonPassword:IsSensitive())
        self.BtnEyePwd:getChildByName("eyeclose"):setVisible(self.EditLogonPassword:IsSensitive())
    end)
	--忘记密码
	utils.RegClickEvent(self.BtnForgetSec, function()
	--	ClsUIManager.GetInstance():ShowPopWnd("clsForgetSec")
		--PlatformHelper.openURL(ClsHomeMgr.GetInstance():GetHomeConfigData().online_service)
        utils.TellMe("请联系在线客服找回密码")
	end)
	
	self.ImgLoginYzm:EnableTouch(function()
		if ClsLoginMgr.GetInstance():Gettoken_private_key() then 
			proto.req_login_code({ token_private_key = ClsLoginMgr.GetInstance():Gettoken_private_key() }) 
		else
			proto.req_login_get_token_private_key(nil,nil,function()
				if ClsLoginMgr.GetInstance():Gettoken_private_key() then
					proto.req_login_code({ token_private_key = ClsLoginMgr.GetInstance():Gettoken_private_key() }) 
				end
			end)
		end
	end)
    --客服
	utils.RegClickEvent(self.Button_Service,function()
		PlatformHelper.openURL(ClsHomeMgr.GetInstance():GetHomeConfigData().online_service)
	end)
	--[[self.EditLogonUsername:registerScriptEditBoxHandler(function(evenName, sender)
		if evenName == "changed" then
			local allusers = UserDefaultData:Getallusers({}) or {}
			local name = self.EditLogonUsername:getString()
			if allusers[name] then
				self.EditLogonPassword:setString(allusers[name])
			else 
				self.EditLogonPassword:setString("")
			end
			self.EditLogonPassword:SetSensitive(self.EditLogonPassword:IsSensitive())
		end
	end)]]--
end

function clsLoginUI4:IsNeedYzm()
	return ClsLoginMgr.GetInstance():LoginNeedYzm()
end

function clsLoginUI4:AdjustUI()
	local options = {
		{ comp = self.PanelUsername, 	checker = function() return true end },
		{ comp = self.PanelPwd, 		checker = function() return true end },
		{ comp = self.PanelYzm, 		checker = function() return ClsLoginMgr.GetInstance():LoginNeedYzm() end },
	}
	
	local curY = -22
	local count = 0
	for idx, info in ipairs(options) do
		local curOpt = options[idx]
		if curOpt.checker() then
			count = count + 1
			curOpt.comp:setVisible(true)
			curOpt.comp:setPositionY(curY-(count-1)*100-50)
		else
			curOpt.comp:setVisible(false)
		end
	end
	curY = curY - count*100-140
	self.BtnLogon:setPositionY(curY)
	self.BtnForgetSec:setPositionY(curY-97)
	self.BtnHitRegist:setPositionY(curY-97)
	
	if self:IsNeedYzm() then
		local cacheDir, cachePath = ClsLoginMgr.GetInstance():GetYzmPath()
		cc.Director:getInstance():getTextureCache():removeTextureForKey(cachePath)
		self.ImgLoginYzm:loadTexture(cachePath)
	end
end

-- 注册全局事件
function clsLoginUI4:InitGlbEvents()
	g_EventMgr:AddListener(self,"on_req_login_code",function(thisObj, recvdata)
		self:AdjustUI()
	end)
	
	g_EventMgr:AddListener(self,"fail_req_login_code",function(thisObj, recvdata)
--		utils.TellMe("验证码拉取失败，请手动刷新")
		self:AdjustUI()
	end)
	
	g_EventMgr:AddListener(self,"error_req_login_code",function(thisObj, recvdata)
--		utils.TellMe("验证码拉取失败，请手动刷新")
		self:AdjustUI()
	end)
	
	g_EventMgr:AddListener(self,"fail_req_login_logon",function(thisObj, recvdata)
		if ClsLoginMgr.GetInstance():Gettoken_private_key() then 
			proto.req_login_code({ token_private_key = ClsLoginMgr.GetInstance():Gettoken_private_key() }) 
		else
			proto.req_login_get_token_private_key(nil,nil,function(RecvData2)
				if ClsLoginMgr.GetInstance():Gettoken_private_key() then
					proto.req_login_code({ token_private_key = ClsLoginMgr.GetInstance():Gettoken_private_key() }) 
				end
			end)
		end
		self:AdjustUI()
	end)
	
	g_EventMgr:AddListener(self,"on_req_home_sysinfo",function(thisObj, recvdata)
		if ClsLoginMgr.GetInstance():LoginNeedYzm() then
			if ClsLoginMgr.GetInstance():Gettoken_private_key() then 
				proto.req_login_code({ token_private_key = ClsLoginMgr.GetInstance():Gettoken_private_key() }) 
			else
				proto.req_login_get_token_private_key(nil,nil,function(RecvData2)
					if ClsLoginMgr.GetInstance():Gettoken_private_key() then
						proto.req_login_code({ token_private_key = ClsLoginMgr.GetInstance():Gettoken_private_key() }) 
					end
				end)
			end
		end
		self:AdjustUI()
	end)
	
	g_EventMgr:AddListener(self, "on_req_login_logon", function(this, recvdata)
		self:removeSelf()
	end)
	
	g_EventMgr:AddListener(self, "INPUT_YZM", function(this)
		self:AdjustUI()
	end)
end
