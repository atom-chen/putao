-------------------
-- 战斗系统
-------------------
module("fight", package.seeall)

FightService = class("FightService", clsCoreObject)
FightService.__is_singleton = true

function FightService:ctor()
	clsCoreObject.ctor(self)
	--
	self._bInFight = false		--入口开关，防止重复进入
	self._bCombating = false	--战斗开关，是否处于战斗中
	self.fightArgu = nil
	self.tFightResult = nil
	self.mCombat = nil
end

function FightService:dtor()
	
end

function FightService:GetXMid() return 1000 end
function FightService:GetYMid() return 500 end
function FightService:GetDis() return 190 end
function FightService:GetSpace() return 150 end

function FightService:IsInFight() return self._bInFight end
function FightService:IsCombating() return self._bCombating end
function FightService:ISAffectEnable() return self.fightArgu.bAffectEnable end
function FightService:GetFightArgu() return self.fightArgu end
function FightService:GetFightResult() return self.tFightResult end
function FightService:GetCombatType() return self.fightArgu and self.fightArgu.sCombatType or const.COMBAT_TYPE.NONE end
function FightService:GetCombatObj() return self.mCombat end
function FightService:IsClickToRun() return not (self._bInFight and self.fightArgu.sCombatType == const.COMBAT_TYPE.Round) end
function FightService:GetCurRound() return self.mCombat:GetCurRound() end

---------------------
-- 流程
---------------------
--战斗系统入口
function FightService:EnterFight(fightArgu)
	--检查参数
	fightArgu:Check()
	
	--防止重复进入
	if self._bInFight then utils.TellMe("已经在战斗中") return end
	self._bInFight = true
	logger.fight("+++++++++ 进入战斗系统 +++++++++")
	
	-- 数据初始化
	assert(self.mCombat==nil)
	self.tFightResult = nil
	self.fightArgu = fightArgu
	
	-- 进入战斗场景
	logger.fight("+++++++++ 进入战斗场景 +++++++++")
	ClsSceneManager.GetInstance():Turn2Scene("clsFightScene", function() self:_OnLoadingOver() end)
end

function FightService:_OnLoadingOver()
	logger.fight("+++++++++ 战斗场景加载完毕 +++++++++")
	
	-- 显示战斗UI
	ClsUIManager.GetInstance():ShowPanel("clsFightUI")
	
	-- 创建战场
	local sCombatType = self.fightArgu.sCombatType
	if sCombatType == const.COMBAT_TYPE.Instant then
		self.mCombat = clsCombatInstant.new()
	elseif sCombatType == const.COMBAT_TYPE.Post then
		self.mCombat = clsCombatPost.new()
	elseif sCombatType == const.COMBAT_TYPE.Round then
		self.mCombat = clsCombatRound.new()
	else 
		assert(false, "未定义的战场类型： "..sCombatType)
	end
	
	-- 3秒后开战
	local compPicNumber = ui.clsPicNumber.new(ClsLayerManager.GetInstance():GetLayer(const.LAYER_WAITING))
	compPicNumber:setPosition(GAME_CONFIG.DESIGN_W_2, GAME_CONFIG.DESIGN_H_2)
	compPicNumber:SetModal(true,true)
	compPicNumber:SetValue(3)
	self:CreateAbsTimerLoop("tmStart", 1, function()
		compPicNumber:SetValue(compPicNumber:GetValue()-1)
		
		if compPicNumber:GetValue() == 0 then
			self:DestroyTimer("tmStart")
			if compPicNumber then
				KE_SafeDelete(compPicNumber)
				compPicNumber = nil
			end
			-- 开战
			self:StartCombat()
		end
	end)
end

--开始战斗
function FightService:StartCombat()
	logger.fight("+++++++++ 战斗开始 +++++++++")
	assert(self._bCombating==false)
	self._bCombating = true
	self.mCombat:StartCombat()
	self:StartCountDown()
end

--战斗结束回调
function FightService:OnCombatEnd(iReason)
	logger.fight("+++++++++ 战斗结束 +++++++++")
	assert(self._bCombating==true)
	self:StopCountDown()
	self.tFightResult = self.mCombat:GetFightResult()
	self._bCombating = false
	
	local funcCallback = self.fightArgu.EndCallback
	if funcCallback then
		funcCallback(self.tFightResult)
	end
	
	self:_LeaveFight()
end

--清理战场
function FightService:_DoCleanup()
	self:StopCountDown()
	if self.mCombat then
		KE_SafeDelete(self.mCombat)
		self.mCombat = nil
	end
end
--离开战斗
function FightService:_LeaveFight()
	-- 3秒后退出战斗
	local compPicNumber = ui.clsPicNumber.new(ClsLayerManager.GetInstance():GetLayer(const.LAYER_WAITING))
	compPicNumber:setPosition(GAME_CONFIG.DESIGN_W_2, GAME_CONFIG.DESIGN_H_2)
	compPicNumber:SetModal(true, true)
	compPicNumber:SetValue(3)
	self:CreateAbsTimerLoop("tmExit", 1, function()
		compPicNumber:SetValue(compPicNumber:GetValue()-1)
		
		if compPicNumber:GetValue() <= 0 then
			self:DestroyTimer("tmExit")
			
			if compPicNumber then
				KE_SafeDelete(compPicNumber)
				compPicNumber = nil
			end
			
			self:_DoCleanup()
			self._bInFight = false
			
			self:_ShowFightResult()
		end
	end)
end

--显示战斗结果
function FightService:_ShowFightResult()
	local bIsWin = self.tFightResult.bWin
	self:_ExitFight()
end

--退出战斗
function FightService:_ExitFight()
	ClsSceneManager.GetInstance():Turn2Scene("clsRestScene")
end

---------------------
-- 计时器
---------------------
function FightService:StartCountDown()
	local TOTAL_SECONDS = self.fightArgu.tFightGoal.goal_time_limit 
	if not (TOTAL_SECONDS and TOTAL_SECONDS > 0) then
		self:StopCountDown() 
		return
	end
	
	local leftTime = TOTAL_SECONDS
	
	self:CreateAbsTimerLoop("tmCountDown", 1, function()
		leftTime = leftTime - 1 
--		logger.fight( string.format("剩余时间：%d/%d", leftTime, TOTAL_SECONDS) )
		if leftTime <= 0 then
			self:DestroyTimer("tmCountDown")
			self.mCombat:StopCombat(const.COMBAT_QUIT_REASON.TIMEOUT)
			return true
		end
	end)
end

function FightService:StopCountDown()
	self:DestroyTimer("tmCountDown")
end

function FightService:PauseCountDown(bPause)
	self:PauseTimer("tmCountDown", bPause)
end

---------------------
--
---------------------

-- 点击退出战斗按钮
function FightService:RequestExit()
	self.mCombat:StopCombat(const.COMBAT_QUIT_REASON.CLICK_QUIT)
end
