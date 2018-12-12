module("ai",package.seeall)

clsCmpEnemyHP = class("clsCmpEnemyHP", clsConditionNode)

function clsCmpEnemyHP:ctor(sCmpType, percent)
	clsConditionNode.ctor(self)
	self._sCmpType = sCmpType
	self._percent = percent
end

function clsCmpEnemyHP:Proc(theOwner)
	return theOwner:ProcCmpEnemyHP(self._sCmpType, self._percent)
end