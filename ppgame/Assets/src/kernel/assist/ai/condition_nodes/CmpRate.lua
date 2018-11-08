module("ai",package.seeall)

clsCmpRate = class("clsCmpRate", clsConditionNode)

function clsCmpRate:ctor(rate)
	clsConditionNode.ctor(self)
	self._rate = rate
end

function clsCmpRate:Proc(theOwner)
	return theOwner:ProcCmpRate(self._rate)
end