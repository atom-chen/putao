module("ai",package.seeall)

clsFindNearestEnemy = class("clsFindNearestEnemy", clsActionNode)

function clsFindNearestEnemy:ctor()
	clsActionNode.ctor(self)
end

function clsFindNearestEnemy:Proc(theOwner)
	return theOwner:ProcFindNearestEnemy(self)
end