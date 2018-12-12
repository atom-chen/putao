module("ai",package.seeall)

clsCastSkill = class("clsCastSkill", clsActionNode)

function clsCastSkill:ctor(iSkillIndex)
	clsActionNode.ctor(self)
	self.iSkillIndex = iSkillIndex
end

function clsCastSkill:Proc(theOwner)
	return theOwner:ProcCastSkill(self, self.iSkillIndex)
end

function clsCastSkill:OnInterrupt(theOwner)
	theOwner:BreakSkill()
end
