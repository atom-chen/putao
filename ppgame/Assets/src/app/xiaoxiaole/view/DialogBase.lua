module("xiaoxiaole", package.seeall)

local DialogBase = class("DialogBase", function()
	
	local node = display.newNode();
	node.setVisibleEx = node.setVisible;
	
	return node;
end)

function DialogBase:ctor(parms)
    parms = parms or {};
    self.m_param = parms
	self.m_release = parms.release

	self:setTouchEnabled(true);
	self:EnableNodeEvents ();
	self.bCloseWhenClickMask = true
end

function DialogBase:setVisible (visible)
	self:setVisibleEx (visible);
end

--管理器时修改
function DialogBase:show()
	self:setVisible(true)
end

-- 关闭
function DialogBase:close()
	self:setVisible(false);
	if self.m_release then
		self:removeSelf()
	end
end

--屏蔽背景点击事件
function DialogBase:removeBgEvent(flag)
	
end

return DialogBase
