-----------------
--
-----------------
clsGrdMovPathState = class("clsGrdMovPathState", clsGrdMovementState)

function clsGrdMovPathState:ctor()
	clsGrdMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_GRDMOVPATH
end

function clsGrdMovPathState:OnEnter(obj, args)
	--if obj:IsInSky() then logger.warn("角色还在空中飘: "..obj:GetPosH()) end
	assert(args.roadpath)
	obj:SetRoadPath(args.roadpath)
	obj.__pathto_callback = args.cbFinish
end

function clsGrdMovPathState:OnExit(obj)
	obj:ClearRoadPath()
	
	if obj.__pathto_callback then
		local pathto_callback = obj.__pathto_callback
		obj.__pathto_callback = nil
		pathto_callback(const.ST_REASON_BREAK)
	end
end

--@每帧更新
function clsGrdMovPathState:FrameUpdate(obj, deltaTime)
	local RoadPath = obj:GetRoadPath()
	
	if RoadPath then
		local x, y, dir, is_end = RoadPath:get_next(obj:GetCurMoveSpeed())
		obj:setPosition(x, y)
		if dir then obj:SetCurDir(dir) end
		if is_end then
			self:OnComplete(obj)
		end
	else
		obj:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
		obj:Turn2ActState(ROLE_STATE.ST_IDLE)
	end
end

function clsGrdMovPathState:OnComplete(obj, args)
	local pathto_callback = obj.__pathto_callback
	obj.__pathto_callback = nil
	
	obj:ClearRoadPath()
	obj:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	obj:Turn2ActState(ROLE_STATE.ST_IDLE)
	
	if pathto_callback then
		pathto_callback(const.ST_REASON_COMPLETE)
	end
end
