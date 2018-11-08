module("ai",package.seeall)

clsChooseCastPoint = class("clsChooseCastPoint", clsActionNode)

function clsChooseCastPoint:ctor()
	clsActionNode.ctor(self)
end

function clsChooseCastPoint:Proc(theOwner)
	return theOwner:ProcChooseCastPoint(self)
end