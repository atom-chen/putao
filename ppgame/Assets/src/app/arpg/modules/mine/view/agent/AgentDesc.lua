-------------------------
-- 代理说明
-------------------------
module("ui", package.seeall)

clsAgentDesc = class("clsAgentDesc", clsBaseUI)

function clsAgentDesc:ctor(parent)
	clsBaseUI.ctor(self, parent, "uistu/AgentDesc.csb")
	self:InitUiEvents()
	self:InitGlbEvents()
	
end

function clsAgentDesc:dtor()
	
end

--注册控件事件
function clsAgentDesc:InitUiEvents()
	utils.RegClickEvent(self.BtnClose, function() self:removeSelf() end)
end

-- 注册全局事件
function clsAgentDesc:InitGlbEvents()
	
end