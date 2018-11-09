---------------------------------
-- 角色状态机（并行状态机）
--
-- 功能：
-- 1.枚举所有最基本的动作状态类型
-- 2.定制状态转换规则
--
-- 状态转换规则：检查跨层阻止通过 and 检查状态转换表通过
-- Note 1. 分为了三个层：动作层、水平移动层、竖直移动层
-- Note 2. 各层是并行的，要注意层与层之间的同步和互斥的协调处理
-- Note 3. 层内部各状态之间一定是互斥的，即同一时刻只能处在某一状态
---------------------------------
local ACTSTATE_TRANS_TABLE = ACTSTATE_TRANS_TABLE
local GRDMOVSTATE_TRANS_TABLE = GRDMOVSTATE_TRANS_TABLE
local SKYMOVSTATE_TRANS_TABLE = SKYMOVSTATE_TRANS_TABLE
local CROSS_LAYER_FORBIT_TABLE = CROSS_LAYER_FORBIT_TABLE

-- 状态表（动作层）
local ACTSTATE_TABLE = {
	[ROLE_STATE.ST_ACTBRIDGE] = clsActBridgeState.GetInstance(),
	--
	[ROLE_STATE.ST_IDLE] 	= clsIdleState.GetInstance(),
	[ROLE_STATE.ST_WALK] 	= clsWalkState.GetInstance(),
	[ROLE_STATE.ST_RUN] 	= clsRunState.GetInstance(),
	[ROLE_STATE.ST_RUSH] 	= clsRushState.GetInstance(),
	[ROLE_STATE.ST_JUMP] 	= clsJumpState.GetInstance(),
	[ROLE_STATE.ST_SKILL] 	= clsSkillState.GetInstance(),
	[ROLE_STATE.ST_DEFEND]	= clsDefendState.GetInstance(),
	--
	[ROLE_STATE.ST_DIE] 	= clsDieState.GetInstance(),
	[ROLE_STATE.ST_REVIVE] 	= clsReviveState.GetInstance(),
	[ROLE_STATE.ST_HIT] 	= clsHitState.GetInstance(),
	[ROLE_STATE.ST_FLIGHT] 	= clsFlightState.GetInstance(),
	[ROLE_STATE.ST_LIE] 	= clsLieState.GetInstance(),
	[ROLE_STATE.ST_FREEZE] 	= clsFreezeState.GetInstance(),
}

-- 状态表（水平移动层）
local GRDMOVSTATE_TABLE = {
	[ROLE_STATE.ST_GRDBRIDGE] = clsGrdBridgeState.GetInstance(),
	--
	[ROLE_STATE.ST_GRDMOVREST] = clsGrdMovRestState.GetInstance(),
	[ROLE_STATE.ST_GRDMOVLINE] = clsGrdMovLineState.GetInstance(),
	[ROLE_STATE.ST_GRDMOVPATH] = clsGrdMovPathState.GetInstance(),
	[ROLE_STATE.ST_GRDMOVFREEZE] = clsGrdMovFreezeState.GetInstance(),
}

-- 状态表（空中移动层）
local SKYMOVSTATE_TABLE = {
	[ROLE_STATE.ST_SKYBRIDGE] = clsSkyBridgeState.GetInstance(),
	--
	[ROLE_STATE.ST_SKYMOVREST] = clsSkyMovRestState.GetInstance(),
	[ROLE_STATE.ST_SKYMOVLINE] = clsSkyMovLineState.GetInstance(),
	[ROLE_STATE.ST_SKYMOVPATH] = clsSkyMovPathState.GetInstance(),
	[ROLE_STATE.ST_SKYMOVFREEZE] = clsSkyMovFreezeState.GetInstance(),
}

------------分割线----------------------------------

ClsStateMgr = class("ClsStateMgr")
ClsStateMgr.__is_singleton = true

function ClsStateMgr:ctor()
	self.tActStateTable = ACTSTATE_TABLE
	self.tGrdMovStateTable = GRDMOVSTATE_TABLE
	self.tSkyMovStateTable = SKYMOVSTATE_TABLE
end

function ClsStateMgr:dtor()
	self.tActStateTable = nil
	self.tGrdMovStateTable = nil
	self.tSkyMovStateTable = nil
end

--@每帧更新
--这里要改，如果在ActState的DieState即角色死亡时立刻干掉对象，会造成后面的两个update使用野指针。
function ClsStateMgr:FrameUpdate(obj, deltaTime)
	obj:GetActStateObj():FrameUpdate(obj, deltaTime)
	obj:GetGrdMovStateObj():FrameUpdate(obj, deltaTime)
	obj:GetSkyMovStateObj():FrameUpdate(obj, deltaTime)
end

------------------------

function ClsStateMgr:ResetStates(obj)
	obj:SetPosH(0)
	self:_SetActState(obj, ROLE_STATE.ST_IDLE)
	self:_SetGrdMovState(obj, ROLE_STATE.ST_GRDMOVREST)
	self:_SetSkyMovState(obj, ROLE_STATE.ST_SKYMOVREST)
end

function ClsStateMgr:CheckCrossLayerForbit(obj, iState)
	if not CROSS_LAYER_FORBIT_TABLE[iState] then return false end
	local forbitTbl = CROSS_LAYER_FORBIT_TABLE[iState]
	return forbitTbl[obj:GetActState()] or forbitTbl[obj:GetGrdMovState()] or forbitTbl[obj:GetSkyMovState()]
end

-----------------------

function ClsStateMgr:CheckActTransTable(iFromState, iToState)
	return iFromState==nil or ACTSTATE_TRANS_TABLE[iToState][iFromState]
end

function ClsStateMgr:Can2ActState(obj, iState)
	-- 检查是否被跨层阻止
	if self:CheckCrossLayerForbit(obj, iState) then
		return false
	end
	-- 检查状态转换表
	if not self:CheckActTransTable(obj:GetActState(), iState) then 
		return false 
	end
	
	return true
end

function ClsStateMgr:_SetActState(obj, iState, args)
	assert(self.tActStateTable[iState], "未定义的状态: "..iState)
	assert(args==nil or is_table(args), "args类型为nil或table")
	
	local oFromState = obj:GetActStateObj() 
	local oToState = self.tActStateTable[iState]
	if obj:IsHero() then logger.state(obj:GetActState(), "---->", iState) end
	if oFromState then oFromState:OnExit(obj) end
	obj:OnActStateChanged(oToState)
	oToState:OnEnter(obj, args)
end

function ClsStateMgr:Turn2ActState(obj, iState, args)
	assert(self.tActStateTable[iState], "未定义的状态: "..iState)
	assert(args==nil or is_table(args), "args类型为nil或table")
	
	if self:Can2ActState(obj, iState) then
		self:_SetActState(obj, iState, args)
		return true
	else
		if obj:IsHero() then logger.state("Can2ActState失败", obj:GetActState(), iState) end
		return false
	end
end

-----------------------

function ClsStateMgr:CheckGrdMovTransTable(iFromState, iToState)
	return iFromState==nil or GRDMOVSTATE_TRANS_TABLE[iToState][iFromState]
end

function ClsStateMgr:Can2GrdMovState(obj, iState)
	-- 检查是否被跨层阻止
	if self:CheckCrossLayerForbit(obj, iState) then
		return false
	end
	-- 检查状态转换表
	if not self:CheckGrdMovTransTable(obj:GetGrdMovState(), iState) then
		return false
	end
	
	return true
end

function ClsStateMgr:_SetGrdMovState(obj, iState, args)
	assert(self.tGrdMovStateTable[iState], "未定义的状态: "..iState)
	assert(args==nil or is_table(args), "args类型为nil或table")
	
	local oFromState = obj:GetGrdMovStateObj()
	local oToState = self.tGrdMovStateTable[iState]
	if obj:IsHero() then logger.state(obj:GetGrdMovState(), "---->", iState) end
	if oFromState then oFromState:OnExit(obj) end
	obj:OnGrdMovStateChanged(oToState)
	oToState:OnEnter(obj, args)
end

function ClsStateMgr:Turn2GrdMovState(obj, iState, args)
	assert(self.tGrdMovStateTable[iState], "未定义的状态: "..iState)
	assert(args==nil or is_table(args), "args类型为nil或table")
	
	if self:Can2GrdMovState(obj, iState) then
		self:_SetGrdMovState(obj, iState, args)
		return true
	else
	if obj:IsHero() then logger.state("Can2GrdMovState失败", obj:GetGrdMovState(), iState) end
		return false
	end
end

-----------------------

function ClsStateMgr:CheckSkyMovTransTable(iFromState, iToState)
	return iFromState==nil or SKYMOVSTATE_TRANS_TABLE[iToState][iFromState]
end

function ClsStateMgr:Can2SkyMovState(obj, iState)
	-- 检查是否被跨层阻止
	if self:CheckCrossLayerForbit(obj, iState) then
		return false
	end
	-- 检查状态转换表
	if not self:CheckSkyMovTransTable(obj:GetSkyMovState(), iState) then
		return false
	end
	
	return true
end

function ClsStateMgr:_SetSkyMovState(obj, iState, args)
	assert(self.tSkyMovStateTable[iState], "未定义的状态: "..iState)
	assert(args==nil or is_table(args), "args类型为nil或table")
	
	local oFromState = obj:GetSkyMovStateObj()
	local oToState = self.tSkyMovStateTable[iState]
	if obj:IsHero() then logger.state(obj:GetSkyMovState(), "---->", iState) end
	if oFromState then oFromState:OnExit(obj) end
	obj:OnSkyMovStateChanged(oToState)
	oToState:OnEnter(obj, args)
end

function ClsStateMgr:Turn2SkyMovState(obj, iState, args)
	assert(self.tSkyMovStateTable[iState], "未定义的状态: "..iState)
	assert(args==nil or is_table(args), "args类型为nil或table")
	
	if self:Can2SkyMovState(obj, iState) then
		self:_SetSkyMovState(obj, iState, args)
		return true
	else
		if obj:IsHero() then logger.state("Can2SkyMovState失败", obj:GetSkyMovState(), iState) end
		return false
	end
end
