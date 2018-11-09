clsFlightState = class("clsFlightState", clsActionState)

function clsFlightState:ctor()
	clsActionState.ctor(self)
	self.Uid = ROLE_STATE.ST_FLIGHT
end

function clsFlightState:OnEnter(obj, args)
	obj:OnEnterState(self)
end

function clsFlightState:OnExit(obj)
	
end

--@每帧更新
function clsFlightState:FrameUpdate(obj, deltaTime)
	if obj:GetCurSkySpeed() > 0 then
		obj:FireEvent("FLIGHT_STEP", true)
	else
		obj:FireEvent("FLIGHT_STEP", false)
	end
end

function clsFlightState:OnComplete(obj, args)
	obj:GetStateMgr():_SetActState(obj, ROLE_STATE.ST_ACTBRIDGE, {to_state = ROLE_STATE.ST_IDLE})
end
