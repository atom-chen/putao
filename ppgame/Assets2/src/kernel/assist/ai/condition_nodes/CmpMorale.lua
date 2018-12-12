module("ai",package.seeall)

-- 士气
clsCmpMorale = class("clsCmpMorale", clsConditionNode)

function clsCmpMorale:ctor(sCmpType, iMorale)
	clsConditionNode.ctor(self)
	self.sCmpType = sCmpType
	self.iMorale = iMorale
end

function clsCmpMorale:Proc(theOwner)
	return theOwner:ProcCmpMorale(self.sCmpType, self.iMorale)
end
