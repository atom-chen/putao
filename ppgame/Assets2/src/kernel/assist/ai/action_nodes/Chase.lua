module("ai",package.seeall)

clsChase = class("clsChase", clsActionNode)

function clsChase:ctor()
	clsActionNode.ctor(self)
end

function clsChase:Proc(theOwner)
	return theOwner:ProcChase(self)
end

function clsChase:OnInterrupt(theOwner)
	theOwner:DoRest()
end
