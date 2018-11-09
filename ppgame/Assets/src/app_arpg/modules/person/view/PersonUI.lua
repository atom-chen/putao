-------------------------
-- 个人信息页面
-------------------------
module("ui", package.seeall)

clsPersonUI = class("clsPersonUI", clsBaseUI)

function clsPersonUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/PersonUI.csb")
end

function clsPersonUI:dtor()
	
end
