module("ai",package.seeall)

bt_hero_fight = class("bt_hero_fight", clsBehaviorTree)
bt_hero_fight.__is_singleton = true

function bt_hero_fight:ctor()
	clsBehaviorTree.ctor(self)
	
	local nodeHasFightTarget = clsHasFightTarget.new()
	local nodeAOI = clsAOI.new(5500)
	local nodeChooseSkill = clsChooseSkill.new()
	local nodeChooseSkill2 = clsChooseSkill.new()
	local nodeCastSkill = clsCastSkill.new()
	local nodeChase = clsChase.new() 
	local nodePatrol = clsPatrol.new(nil, nil, 100)
	local nodeFindNear = clsFindNearestEnemy.new()
	local nodeRest = clsRest.new(15)
	
	self:SetRootNode(nodeHasFightTarget)
	nodeHasFightTarget:SetRightNode(nodeChooseSkill)
	nodeChooseSkill:SetRightNode(nodeCastSkill)
	nodeCastSkill:SetRightNode(nodeRest)
	nodeChooseSkill:SetLeftNode(nodeFindNear)
	nodeHasFightTarget:SetLeftNode(nodeFindNear)
	nodeFindNear:SetRightNode(nodeChooseSkill2)
	nodeChooseSkill2:SetRightNode(nodeCastSkill)
	nodeChooseSkill2:SetLeftNode(nodeChase)
	nodeFindNear:SetLeftNode(nodePatrol)
end
