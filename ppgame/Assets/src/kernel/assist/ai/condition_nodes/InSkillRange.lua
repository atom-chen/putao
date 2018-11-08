module("ai",package.seeall)

clsInSkillRange = class("clsInSkillRange", clsConditionNode)

function clsInSkillRange:ctor(iSkillIndex)
	clsConditionNode.ctor(self)
	self.iSkillIndex = iSkillIndex
end

function clsInSkillRange:Proc(theOwner)
	return theOwner:ProcInSkillRange(self.iSkillIndex)
end