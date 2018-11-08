module("ai",package.seeall)

clsRest = class("clsRest", clsActionNode)

function clsRest:ctor(iTotalFrames)
	clsActionNode.ctor(self)
	self.iTotalFrames = iTotalFrames
end

function clsRest:Proc(theOwner)
	return theOwner:ProcRest(self, self.iTotalFrames)
end

function clsRest:OnInterrupt(theOwner)
	theOwner:DestroyTimer("tm_ai_rest")
end