clsSkyBridgeState = class("clsSkyBridgeState", clsSkyMovementState)

function clsSkyBridgeState:ctor()
	clsSkyMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_SKYBRIDGE
end

function clsSkyBridgeState:OnEnter(obj, args)
--	logger.state("Sky Bridge To: ", args.to_state)
	assert(args.to_state, "没有告知桥接到哪个状态")
	obj:GetStateMgr():_SetSkyMovState(obj, args.to_state, args.param)
end

function clsSkyBridgeState:OnExit(obj)
--	logger.state("exit Bridge")
end

--@每帧更新
function clsSkyBridgeState:FrameUpdate(obj, deltaTime)
--	logger.state("------>")
end
