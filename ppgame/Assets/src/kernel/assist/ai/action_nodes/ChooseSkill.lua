module("ai",package.seeall)

clsChooseSkill = class("clsChooseSkill", clsActionNode)

function clsChooseSkill:ctor()
	clsActionNode.ctor(self)
end

function clsChooseSkill:Proc(theOwner)
	return theOwner:ProcChooseSkill(self)
end