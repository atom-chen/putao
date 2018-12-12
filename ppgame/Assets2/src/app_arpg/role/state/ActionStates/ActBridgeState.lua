clsActBridgeState = class("clsActBridgeState", clsActionState)

function clsActBridgeState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_ACTBRIDGE
end

function clsActBridgeState:OnEnter(obj, args)
--	logger.state("Act Bridge To: ", args.to_state)
	assert(args.to_state, "没有告知桥接到哪个状态")
	obj:GetStateMgr():_SetActState(obj, args.to_state, args.param)
end

function clsActBridgeState:OnExit(obj)
--	logger.state("exit Bridge")
end

--@每帧更新
function clsActBridgeState:FrameUpdate(obj, deltaTime)
--	logger.state("------>")
end
