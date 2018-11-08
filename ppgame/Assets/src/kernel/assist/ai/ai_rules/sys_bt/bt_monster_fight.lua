module("ai",package.seeall)

bt_monster_fight = class("bt_monster_fight", clsBehaviorTree)
bt_monster_fight.__is_singleton = true

function bt_monster_fight:ctor()
	clsBehaviorTree.ctor(self)
	
	local nodeHasFightTarget = clsHasFightTarget.new()
	local nodeAOI = clsAOI.new(500)
	local nodeChooseSkill = clsChooseSkill.new()
	local nodeCastSkill = clsCastSkill.new()
	local nodeChase = clsChase.new() 
	local nodePatrol = clsPatrol.new(nil, nil, 100)
	local nodeEscape = clsEscape.new()
	local nodeTryEscape = clsAndCompositeNode.new({
			clsIsEscapeHP.new(0.8),
			clsCmpRate.new(function(theOwner) return (1-theOwner:GetHPPercent())*0.8 end) 
	})
	local nodeFindNear = clsFindNearestEnemy.new()
	local nodeRest = clsRest.new(60)

	
	self:SetRootNode(nodeHasFightTarget)
	nodeHasFightTarget:SetRightNode(nodeTryEscape)
	nodeTryEscape:SetRightNode(nodeEscape)
	nodeTryEscape:SetLeftNode(nodeChooseSkill)
	nodeChooseSkill:SetRightNode(nodeCastSkill)
	nodeCastSkill:SetRightNode(nodeRest)
	nodeChooseSkill:SetLeftNode(nodeChase)
	nodeHasFightTarget:SetLeftNode(nodeAOI)
	nodeAOI:SetRightNode(nodeChooseSkill)
	nodeAOI:SetLeftNode(nodeFindNear)
	nodeFindNear:SetRightNode(nodeChase)
	nodeFindNear:SetLeftNode(nodePatrol)
end
