module("ai",package.seeall)

clsIsEscapeHP = class("clsIsEscapeHP", clsConditionNode)

function clsIsEscapeHP:ctor(escapeHP)
	clsConditionNode.ctor(self)
	self._iEscapeHP = escapeHP
end

function clsIsEscapeHP:Proc(theOwner)
	return theOwner:ProcIsEscapeHP(self._iEscapeHP)
end