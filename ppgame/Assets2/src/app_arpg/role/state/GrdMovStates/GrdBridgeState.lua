clsGrdBridgeState = class("clsGrdBridgeState", clsGrdMovementState)

function clsGrdBridgeState:ctor()
	clsGrdMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_GRDBRIDGE
end

function clsGrdBridgeState:OnEnter(obj, args)
--	logger.state("Grd Bridge To: ", args.to_state)
	assert(args.to_state, "没有告知桥接到哪个状态")
	obj:GetStateMgr():_SetGrdMovState(obj, args.to_state, args.param)
end

function clsGrdBridgeState:OnExit(obj)
--	logger.state("exit Bridge")
end

--@每帧更新
function clsGrdBridgeState:FrameUpdate(obj, deltaTime)
--	logger.state("------>")
end
