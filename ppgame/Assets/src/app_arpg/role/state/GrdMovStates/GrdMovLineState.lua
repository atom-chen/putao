clsGrdMovLineState = class("clsGrdMovLineState", clsGrdMovementState)

function clsGrdMovLineState:ctor()
	clsGrdMovementState.ctor(self)
	self.Uid = ROLE_STATE.ST_GRDMOVLINE
end

function clsGrdMovLineState:OnEnter(obj, args)
	--assert(args.movSpeed > 0, "移动速度必须大于0")
	--assert(args.movFrame > 0, "移动帧数必须大于0")
	local movDir = args.movDir
	local movFrame = args.movFrame
	local movSpeed = args.movSpeed
	
	obj:SetCurMoveSpeed(movSpeed)
	
	if movSpeed<=0 or movFrame<=0 then
		self:OnComplete(obj)
	else 
		obj.iMoveFrame = movFrame
		obj.iTmpSpeedX = movSpeed * math.cos(movDir)
		obj.iTmpSpeedY = movSpeed * math.sin(movDir)
	end
end

function clsGrdMovLineState:OnExit(obj)
	obj.iMoveFrame = 0
	obj.iTmpSpeedX = 0
	obj.iTmpSpeedY = 0
end

--@每帧更新
function clsGrdMovLineState:FrameUpdate(obj, deltaTime)
	obj.iMoveFrame = obj.iMoveFrame - 1
	
	local x,y = obj:getPosition()
	obj:SetPosX(x+obj.iTmpSpeedX)
	obj:SetPosY(y+obj.iTmpSpeedY)
	
	if obj.iMoveFrame <= 0 then
		self:OnComplete(obj)
	end
end

function clsGrdMovLineState:OnComplete(obj, args)
	obj:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	obj:Turn2ActState(ROLE_STATE.ST_IDLE)
end
