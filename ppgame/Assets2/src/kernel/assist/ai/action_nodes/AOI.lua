module("ai",package.seeall)

clsAOI = class("clsAOI", clsActionNode)

function clsAOI:ctor(iRange)
	clsActionNode.ctor(self)
	self.iRange = iRange
end

function clsAOI:Proc(theOwner)
	return theOwner:ProcAOI(self, self.iRange)
end
