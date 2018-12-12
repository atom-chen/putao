----------------
-- 战斗场景
----------------
clsRestScene = class("clsRestScene", clsScene)

function clsRestScene:ctor(world_id, map_id)
	assert(world_id and map_id)
	clsScene.ctor(self, world_id, map_id)
	ClsUIManager.GetInstance():ShowView("clsMainUI")
	
	local heroInfo = { Uid=1, TypeId=10001 }
	local heroObj = ClsRoleEntityMgr.GetInstance():UpdateHero(heroInfo)
	
	local heroSpr = ClsRoleSprMgr.GetInstance():CreateHero()
	heroSpr:EnterMap(500,200)
	VVDirector:GetMap():BindCameraOn(heroSpr)
	
--	VVDirector:GetMap():SetCameraPos(0,0)
end

function clsRestScene:dtor()
	
end

const.SCENE_CFG.clsRestScene = {scene_cls = clsRestScene, scene_id=1001, map_id=1001}
