module("ai",package.seeall)

bt_post_fight = class("bt_post_fight", clsBehaviorTree)
bt_post_fight.__is_singleton = true

function bt_post_fight:ctor()
	clsBehaviorTree.ctor(self)
	
	local nodeCastSkill5 = clsCastSkill.new(5)
	local nodeCastSkill4 = clsCastSkill.new(4)
	local nodeCastSkill3 = clsCastSkill.new(3)
	local nodeCastSkill2 = clsCastSkill.new(2)
	local nodeCastSkill1 = clsCastSkill.new(1)
	local nodeRest = clsRest.new(3)
	
	self:SetRootNode(nodeCastSkill5)
	nodeCastSkill5:SetLeftNode(nodeCastSkill4)
	nodeCastSkill4:SetLeftNode(nodeCastSkill3)
	nodeCastSkill3:SetLeftNode(nodeCastSkill2)
	nodeCastSkill2:SetLeftNode(nodeCastSkill1)
	nodeCastSkill1:SetLeftNode(nodeRest)
	nodeCastSkill1:SetRightNode(nodeRest)
end
