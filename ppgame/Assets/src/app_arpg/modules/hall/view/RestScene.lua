----------------
-- 战斗场景
----------------
clsRestScene = class("clsRestScene", clsScene)

function clsRestScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsScene.ctor(self, world_id, map_id)
	ClsUIManager.GetInstance():ShowView("clsMainUI")
end

function clsRestScene:dtor()
	
end

const.SCENE_CFG.clsRestScene = {scene_cls = clsRestScene, scene_id=1001, map_id=1001}
