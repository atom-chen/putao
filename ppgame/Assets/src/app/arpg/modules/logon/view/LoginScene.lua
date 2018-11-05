-------------------------
-- 登录场景
-------------------------
clsLoginScene = class("clsLoginScene", clsScene)

function clsLoginScene:ctor()
	clsScene.ctor(self)
	
	ClsUIManager.GetInstance():ShowView("clsLoginUI4").BtnClose:setVisible(false)
	
--	require("test.testResource").TestRenderTex(self)
--	require("test.testFuncs").testContainerInterface(self)
end

function clsLoginScene:dtor()
	
end

const.SCENE_CFG.clsLoginScene = {scene_cls = clsLoginScene}
