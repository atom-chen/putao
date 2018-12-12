module("ai",package.seeall)

clsIsTargetCanBeAttack = class("clsIsTargetCanBeAttack", clsConditionNode)

function clsIsTargetCanBeAttack:ctor(targetID)
	clsConditionNode.ctor(self)
	self._targetID = targetID
end

function clsIsTargetCanBeAttack:Proc(theOwner)
	return theOwner:ProcIsTargetCanBeAttack(self._targetID)
end