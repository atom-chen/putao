-------------------------
-- 消消乐进入页面
-------------------------
module("xiaoxiaole", package.seeall)

clsXiaoxiaoleEntryScene = class("clsXiaoxiaoleEntryScene", clsScene)

function clsXiaoxiaoleEntryScene:ctor()
	clsScene.ctor(self)
	local rootlayer = utils.LoadCsb("xiaoxiaole/XxlMainUI.csb")
	self:addChild(rootlayer)
	utils.getNamedNodes(rootlayer, self)
	
	utils.RegClickEvent(self.BtnEnter, function()
		ClsSceneManager.GetInstance():Turn2Scene("clsXiaoxiaoleStageScene")
	end)
	
	self.ImgBg:setContentSize(GAME_CONFIG.SCREEN_W, GAME_CONFIG.SCREEN_H)
	self.ImgBg:setScale(GAME_CONFIG.DESIGN_W/GAME_CONFIG.SCREEN_W, GAME_CONFIG.DESIGN_H/GAME_CONFIG.SCREEN_H)
end

function clsXiaoxiaoleEntryScene:dtor()
	
end

const.SCENE_CFG.clsXiaoxiaoleEntryScene = { scene_cls = clsXiaoxiaoleEntryScene }
