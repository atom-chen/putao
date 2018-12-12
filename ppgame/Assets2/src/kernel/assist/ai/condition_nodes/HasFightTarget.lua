module("ai",package.seeall)

clsHasFightTarget = class("clsHasFightTarget", clsConditionNode)

function clsHasFightTarget:ctor()
	clsConditionNode.ctor(self)
end

function clsHasFightTarget:Proc(theOwner)
	return theOwner:ProcHasFightTarget()
end