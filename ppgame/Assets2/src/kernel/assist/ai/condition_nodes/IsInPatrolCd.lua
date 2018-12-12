module("ai",package.seeall)

clsIsInPatrolCd = class("clsIsInPatrolCd", clsConditionNode)

function clsIsInPatrolCd:ctor()
	clsConditionNode.ctor(self)
end

function clsIsInPatrolCd:Proc(theOwner)
	return theOwner:ProcIsInPatrolCd(self._iSkillId)
end
