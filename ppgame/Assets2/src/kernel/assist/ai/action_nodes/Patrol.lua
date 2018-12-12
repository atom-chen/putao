module("ai",package.seeall)

clsPatrol = class("clsPatrol", clsActionNode)

function clsPatrol:ctor(iPatrolX, iPatrolY, iRange)
	clsActionNode.ctor(self)
	self.iPatrolX, self.iPatrolY = iPatrolX, iPatrolY
	self.iRange = iRange
end

function clsPatrol:Proc(theOwner)
	return theOwner:ProcPatrol(self, self.iPatrolX, self.iPatrolY, self.iRange)
end

function clsPatrol:OnInterrupt(theOwner)
	theOwner:DoRest()
end
