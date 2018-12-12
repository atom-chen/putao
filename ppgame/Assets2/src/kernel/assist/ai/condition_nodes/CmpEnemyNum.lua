module("ai",package.seeall)

clsCmpEnemyNum = class("clsCmpEnemyNum", clsConditionNode)

function clsCmpEnemyNum:ctor(sCmpType, iNum)
	clsConditionNode.ctor(self)
	self._sCmpType = sCmpType
	self._iCount = iNum
end

function clsCmpEnemyNum:Proc(theOwner)
	return theOwner:ProcCmpEnemyNum(self._sCmpType, self._iCount)
end