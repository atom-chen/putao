-------------------------
-- 登录场景
-------------------------
clsLoginScene2 = class("clsLoginScene2", clsScene)

function clsLoginScene2:ctor()
	clsScene.ctor(self)
	ClsUIManager.GetInstance():ShowPanel("clsLoginUI")
	
	local roleObj = clsRoleFighter.new(1,10001)
end

function clsLoginScene2:dtor()
	
end

function clsLoginScene2:onEnter()
	logger.warn("++++++++++++++ login scene onEnter")
end 

function clsLoginScene2:onExit()
	logger.warn("++++++++++++++ login scene onExit")
end 

const.SCENE_CFG.clsLoginScene2 = {scene_cls = clsLoginScene2}
