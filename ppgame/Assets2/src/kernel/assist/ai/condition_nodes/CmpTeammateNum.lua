module("ai",package.seeall)

clsCmpTeammateNum = class("clsCmpTeammateNum", clsConditionNode)

function clsCmpTeammateNum:ctor(sCmpType, iNum)
	clsConditionNode.ctor(self)
	self._sCmpType = sCmpType
	self._iCount = iNum
end

function clsCmpTeammateNum:Proc(theOwner)
	return theOwner:ProcCmpTeammateNum(self._sCmpType, self._iCount)
end