module("ai",package.seeall)

clsEscape = class("clsEscape", clsActionNode)

function clsEscape:ctor(dis)
	clsActionNode.ctor(self)
	self._dis = dis or 150
end

function clsEscape:Proc(theOwner)
	return theOwner:ProcEscape(self, self._dis)
end

function clsEscape:OnInterrupt(theOwner)
	theOwner:DoRest()
end
