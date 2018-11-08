module("ai",package.seeall)

clsFindDensestPoint = class("clsFindDensestPoint", clsActionNode)

function clsFindDensestPoint:ctor()
	clsActionNode.ctor(self)
end

function clsFindDensestPoint:Proc(theOwner)
	return theOwner:ProcFindDensestPoint(self)
end