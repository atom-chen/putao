-------------------------
-- 排行榜页面
-------------------------
module("ui", package.seeall)

clsRankUI = class("clsRankUI", clsBaseUI)

function clsRankUI:ctor(parent)
	clsBaseUI.ctor(self, parent, "res/uistu/RankUI.csb")
	self.iHighX = self.sprHigh:getPositionX()
	self.iHighW = self.sprHigh:getContentSize().width
	self.tabList = { self.BtnChaim, self.BtnConcern, self.BtnTuijian }
	self:InitUiEvents()
end

function clsRankUI:dtor()
	
end

function clsRankUI:InitUiEvents()
	--关闭
	utils.RegClickEvent(self.BtnClose, function()
		self:removeSelf()
	end)
	--
	for i=1, 3 do 
		utils.RegClickEvent(self.tabList[i], function()
			self.sprHigh:setPositionX(self.iHighX+(i-1)*self.iHighW)
		end)
	end 
end
