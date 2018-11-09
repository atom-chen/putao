-------------------------
-- 任务页面
-------------------------
module("ui", package.seeall)

clsTaskUI = class("clsTaskUI", clsBaseUI)

function clsTaskUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/TaskUI.csb")
	self.ListView_1:setItemModel(self.ListItem)
	self.ListItem:removeSelf()
	self:InitUiEvents()
	self:RefleshUI()
end

function clsTaskUI:dtor()
	
end

function clsTaskUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
end

function clsTaskUI:RefleshUI()
	for i=1, 20 do
		self.ListView_1:pushBackDefaultItem()
	end
end
