----------------
-- 战斗场景
----------------
clsFightScene = class("clsFightScene", clsScene)

function clsFightScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsScene.ctor(self, world_id, map_id)
end

function clsFightScene:dtor()
	
end

const.SCENE_CFG.clsFightScene = {scene_cls = clsFightScene}
