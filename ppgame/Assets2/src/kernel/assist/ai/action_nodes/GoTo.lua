module("ai",package.seeall)

clsGoTo = class("clsGoTo", clsActionNode)

function clsGoTo:ctor(sMoveType)
	clsActionNode.ctor(self)
	self.sMoveType = sMoveType
	assert(sMoveType=="run" or sMoveType=="walk" or sMoveType=="rush")
end

function clsGoTo:Proc(theOwner)
	return theOwner:ProcGoTo(self, self.sMoveType)
end

function clsGoTo:OnInterrupt(theOwner)
	theOwner:DoRest()
end
