module("ai",package.seeall)

clsIsCastingSkill = class("clsIsCastingSkill", clsConditionNode)

function clsIsCastingSkill:ctor()
	clsConditionNode.ctor(self)
end

function clsIsCastingSkill:Proc(theOwner)
	return theOwner:ProcIsCastingSkill()
end