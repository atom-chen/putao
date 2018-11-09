-------------------------
-- 个人页
-------------------------
module("ui", package.seeall)

clsPersonalUI = class("clsPersonalUI", clsBaseUI)

function clsPersonalUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/PersonalUI.csb")
	self:InitUiEvents()
end

function clsPersonalUI:dtor()
	
end

function clsPersonalUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
	--邮件
	utils.RegClickEvent(self.BtnMail, function()
		
	end)
	--更多
	utils.RegClickEvent(self.BtnMore, function()
		ClsUIManager.GetInstance():ShowPanel("clsMoreUI")
	end)
	--修改名字
	utils.RegClickEvent(self.BtnChgInfomation, function()
		
	end)
end
