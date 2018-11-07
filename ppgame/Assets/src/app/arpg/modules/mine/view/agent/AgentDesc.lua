-------------------------
-- 代理说明
-------------------------
module("ui", package.seeall)

clsAgentDesc = class("clsAgentDesc", clsBaseUI)

function clsAgentDesc:ctor(parent)
	clsBaseUI.ctor(self, parent, "uistu/AgentDesc.csb")
	self:InitUiEvents()
	self:InitGlbEvents()
	self:RefreshUI()
end

function clsAgentDesc:dtor()
	
end

function clsAgentDesc:RefreshUI()
    self.Text_3:getVirtualRenderer():setLineSpacing(10)
    self.Text_5:getVirtualRenderer():setLineSpacing(10)
    self.Text_7:getVirtualRenderer():setLineSpacing(10)
    self.Text_9:getVirtualRenderer():setLineSpacing(10)
end

--注册控件事件
function clsAgentDesc:InitUiEvents()
	utils.RegClickEvent(self.BtnClose, function() self:removeSelf() end)
end

-- 注册全局事件
function clsAgentDesc:InitGlbEvents()
	
end