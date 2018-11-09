----------------
-- 战斗场景
----------------
clsRestScene = class("clsRestScene", clsScene)

function clsRestScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsScene.ctor(self, world_id, map_id)
	ClsUIManager.GetInstance():ShowPanel("clsMainUI")
end

function clsRestScene:dtor()
	
end

const.SCENE_CFG.clsRestScene = {scene_cls = clsRestScene}
