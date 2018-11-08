module("ai",package.seeall)

clsCmpTargetDistance = class("clsCmpTargetDistance", clsConditionNode)

function clsCmpTargetDistance:ctor(sCmpType, iDistance)
	clsConditionNode.ctor(self)
	self._sCmpType = sCmpType
	self._iDistance = iDistance
end

function clsCmpTargetDistance:Proc(theOwner)
	return theOwner:ProcCmpTargetDistance(self._sCmpType, self._iDistance)
end