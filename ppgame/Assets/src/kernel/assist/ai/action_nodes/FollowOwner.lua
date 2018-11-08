module("ai",package.seeall)

clsFollowOwner = class("clsFollowOwner", clsActionNode)

function clsFollowOwner:ctor(sTarget)
	clsActionNode.ctor(self)
end

function clsFollowOwner:Proc(theOwner)
	return theOwner:ProcFollowOwner(self, sTarget)
end