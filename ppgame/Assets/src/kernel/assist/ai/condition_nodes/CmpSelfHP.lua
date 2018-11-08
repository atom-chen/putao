module("ai",package.seeall)

clsCmpSelfHP = class("clsCmpSelfHP", clsConditionNode)

function clsCmpSelfHP:ctor(sCmpType, percent)
	clsConditionNode.ctor(self)
	self._sCmpType = sCmpType
	self._percent = percent
end

function clsCmpSelfHP:Proc(theOwner)
	return theOwner:ProcCmpSelfHP(self._sCmpType, self._percent)
end