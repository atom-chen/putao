module("ai",package.seeall)

-- 愤怒值
clsCmpAnger = class("clsCmpAnger", clsConditionNode)

function clsCmpAnger:ctor(sCmpType, iAngerValue)
	clsConditionNode.ctor(self)
	self._sCmpType = sCmpType
	self._iAngerValue = iAngerValue
end

function clsCmpAnger:Proc(theOwner)
	return theOwner:ProcCmpAnger(self._sCmpType, self._iAngerValue)
end