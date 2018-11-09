------------------
-- 角色基类
-- 数据、状态、AI
------------------
local ParentCls = clsActor3D
assert(ParentCls)

clsRoleSpr = class("clsRoleSpr", ParentCls)

-- 构造函数
function clsRoleSpr:ctor(iUid)
	local entityObj = ClsRoleEntityMgr.GetInstance():GetRole(iUid)
	assert(entityObj, string.format("不存在该RoleEntity：Uid=%d",iUid))
	ParentCls.ctor(self, nil, entityObj)
	--
	self.Uid = iUid
	
	-- 根据属性数据刷新外形
	self:SetName(self._entityObj:GetNick())

	ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_ROLE)
end

--析构函数
function clsRoleSpr:dtor()
	self._entityObj:DelListener(self)
	self._entityObj:GetBuffMgr():DelListener(self)
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	self:LeaveMap()
end

--@每帧更新
function clsRoleSpr:FrameUpdate(deltaTime)
	self._entityObj:FrameUpdate(deltaTime)
end

--
function clsRoleSpr:IsTempRole() return self.Uid < 0 end
function clsRoleSpr:IsHero() return self:GetRoleType() == const.ROLE_TYPE.TP_HERO end
function clsRoleSpr:IsNpc() return self:GetRoleType() == const.ROLE_TYPE.TP_NPC end
function clsRoleSpr:IsMonster() return self:GetRoleType() == const.ROLE_TYPE.TP_MONSTER end
function clsRoleSpr:IsPlayer() return self:GetRoleType() == const.ROLE_TYPE.TP_PLAYER end
--
function clsRoleSpr:GetUid() return self.Uid end
function clsRoleSpr:GetRoleType() return const.ROLE_TYPE.TP_UNKNOWN end
function clsRoleSpr:GetRoleEntity() return self._entityObj end
function clsRoleSpr:GetStateMgr() return self._entityObj.mStateMgr end
--
function clsRoleSpr:GetHPPercent() return self._entityObj:GetCurHP()/self._entityObj:GetMaxHP() end
function clsRoleSpr:GetCurHP() return self._entityObj:GetCurHP() end

-------------------------
-- 
-------------------------
function clsRoleSpr:EnterMap(x, y)
	if VVDirector:GetMap() then VVDirector:GetMap():AddObject(self, x, y) end
	self:ResetStates()
end

function clsRoleSpr:LeaveMap()
	if VVDirector:GetMap() then VVDirector:GetMap():RemoveObject(self) end
end

-------------------------
-- AI 
-------------------------


-------------------------
-- 状态相关
-------------------------
function clsRoleSpr:IsDead() return self._entityObj:IsDead() end
function clsRoleSpr:GetActState() return self._entityObj:GetActState() end
function clsRoleSpr:GetGrdMovState() return self._entityObj:GetGrdMovState() end
function clsRoleSpr:GetSkyMovState() return self._entityObj:GetSkyMovState() end
function clsRoleSpr:GetActStateObj() return self._entityObj.mActState end
function clsRoleSpr:GetGrdMovStateObj() return self._entityObj.mGrdMovState end
function clsRoleSpr:GetSkyMovStateObj() return self._entityObj.mSkyMovState end

function clsRoleSpr:ResetStates()
	self._entityObj:ResetStates()
end
function clsRoleSpr:Turn2ActState(iState, args)
	return self._entityObj:Turn2ActState(iState, args)
end
function clsRoleSpr:Turn2GrdMovState(iState, args)
	return self._entityObj:Turn2GrdMovState(iState, args)
end
function clsRoleSpr:Turn2SkyMovState(iState, args)
	return self._entityObj:Turn2SkyMovState(iState, args)
end

-------------------
-- 角色行动力
-------------------
--站立
function clsRoleSpr:DoRest()
	return self._entityObj:DoRest()
end
--冲刺
function clsRoleSpr:DoRush(dx, dy, distance, cbFinish)
	return self._entityObj:DoRush(dx, dy, distance, cbFinish)
end
--奔跑
function clsRoleSpr:DoRun(dx, dy, distance, cbFinish)
	return self._entityObj:DoRun(dx, dy, distance, cbFinish)
end
--行走
function clsRoleSpr:DoWalk(dx, dy, distance, cbFinish)
	return self._entityObj:DoWalk(dx, dy, distance, cbFinish)
end
--跳跃
function clsRoleSpr:DoJump(dx, dy, distance, cbFinish)
	return self._entityObj:DoJump(dx, dy, distance, cbFinish)
end
--攻击
function clsRoleSpr:DoSkill(iSkillIndex, sklArgu, cbFinish)
	return self._entityObj:DoSkill(iSkillIndex, sklArgu, cbFinish)
end
--防御
function clsRoleSpr:DoDefend(cbFinish)
	return self._entityObj:DoDefend(cbFinish)
end
--收技
function clsRoleSpr:DoStopSkill()
	return self._entityObj:DoStopSkill()
end
--采集
function clsRoleSpr:DoGather(cbFinish)
	return self._entityObj:DoGather(cbFinish)
end
--打坐
function clsRoleSpr:DoZazen(cbFinish)
	return self._entityObj:DoZazen(cbFinish)
end
--打断技能
function clsRoleSpr:BreakSkill()
	return self._entityObj:BreakSkill()
end


-------------------------
-- 战斗相关
-------------------------
function clsRoleSpr:OnAddBuff(buffObj)
	self:RefleshBuffIcons()
	
	if buffObj then 
		local piaoZi = buffObj:GetBuffPiaoZi()
		if piaoZi and piaoZi ~= "" then
			local sprPiaoZi = cc.Sprite:create(piaoZi)
			self:addChild(sprPiaoZi)
			sprPiaoZi:setScale(1.5)
			sprPiaoZi:setPosition(0,self:GetBodyHeight())
			sprPiaoZi:runAction(cc.Sequence:create(
				cc.MoveBy:create(0.8,cc.p(0,60)),
				cc.RemoveSelf:create()
			))
		end
	end 
end 

function clsRoleSpr:OnDelBuff(buffObj)
	self:RefleshBuffIcons()
end 

function clsRoleSpr:RefleshBuffIcons()
	local col = 5
	local bottom = self:GetBodyHeight() + 30
	local buffList = self._entityObj:GetBuffMgr():GetBuffList()
	self._buffIcons = self._buffIcons or {}
	
	local oldCnt = #self._buffIcons
	local iconCnt = 0
	for idx, buffObj in ipairs(buffList) do 
		local respath = buffObj:GetBuffIcon()
		if respath and respath ~= "" then
			iconCnt = iconCnt + 1
			if self._buffIcons[iconCnt] then
				self._buffIcons[iconCnt]:setTexture(respath)
				self._buffIcons[iconCnt]:setVisible(true)
			else 
				self._buffIcons[iconCnt] = cc.Sprite:create(respath)
				self:addChild(self._buffIcons[iconCnt])
			end 
			local sprIcon = self._buffIcons[iconCnt]
			local c = iconCnt % col  
			if c==0 then c = col end 
			sprIcon:setPosition( (c-(col+1)/2)*25, bottom+math.ceil(iconCnt/col)*25 )
		end
	end 
	
	for i=iconCnt+1, oldCnt do 
		if iconCnt <= 20 then
			self._buffIcons[i]:setVisible(false)
		else 
			KE_SafeDelete(self._buffIcons[i])
			self._buffIcons[i] = nil 
		end 
	end 
end 

-------------------------
-- 事件
-------------------------
function clsRoleSpr:InitEventListeners()
	ParentCls.InitEventListeners(self)
	self._entityObj:AddListener(self, "CurHP", self.OnCurHP, self, true)
	self._entityObj:AddListener(self, "MaxHP", self.OnMaxHP, self, true)
	self._entityObj:AddListener(self, "ENTER_STATE", self.OnEnterState, self)
	self._entityObj:AddListener(self, "EXIT_STATE", self.OnExitState, self)
	self._entityObj:AddListener(self, "FLIGHT_STEP", self.OnFlightStep, self)
	self._entityObj:GetBuffMgr():AddListener(self,"add_buff",self.OnAddBuff,self,true)
	self._entityObj:GetBuffMgr():AddListener(self,"del_buff",self.OnDelBuff,self)
end

function clsRoleSpr:OnCurHP(Value, oldValue)
	self:RefleshBloodBar()
	if Value and oldValue then
		if Value - oldValue ~= 0 then
			self:PlayFlyBlood(Value - oldValue)
		end
	end
end

function clsRoleSpr:OnMaxHP(Value, oldValue)
	self:RefleshBloodBar()
end

function clsRoleSpr:OnFlightStep(bUp)
	if bUp then
		self:PlayAni(const.ANINAME.flight_up)
	else
		self:PlayAni(const.ANINAME.flight_down)
	end
end

local MAP_STATE_ENTER = {
	[ROLE_STATE.ST_DEFEND] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.def)
	end,
	[ROLE_STATE.ST_DIE] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.die,1)
		roleSpr:PauseAni()
	end,
	[ROLE_STATE.ST_FREEZE] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.abn)
		roleSpr.iceSpr = cc.Sprite:create("effects/effect_img/ice.png")
		KE_SetParent(roleSpr.iceSpr, roleSpr)
		roleSpr.iceSpr:setPosition(0,100)
	end,
	[ROLE_STATE.ST_HIT] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.hit, 1)
		roleSpr:GetBody():setColor(cc.c3b(250, 0, 0))
	end,
	[ROLE_STATE.ST_IDLE] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.stand)
	end,
	[ROLE_STATE.ST_JUMP] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.win)
	end,
	[ROLE_STATE.ST_RUN] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.run)
	end,
	[ROLE_STATE.ST_RUSH] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.run)
		roleSpr:PauseAni()
	end,
	[ROLE_STATE.ST_WALK] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.walk)
	end,
	[ROLE_STATE.ST_REVIVE] = function(roleSpr)
		roleSpr:PlayAni(const.ANINAME.stand)
	end,
}
function clsRoleSpr:OnEnterState(oState, args)
	local func = MAP_STATE_ENTER[oState:GetUid()]
	if func then func(self) end
end

local MAP_STATE_EXIT = {
	[ROLE_STATE.ST_FREEZE] = function(roleSpr)
		KE_SafeDelete(roleSpr.iceSpr)
		roleSpr.iceSpr = nil
	end,
	[ROLE_STATE.ST_HIT] = function(roleSpr)
		roleSpr:GetBody():setColor(cc.c3b(255, 255, 255))
	end,
	[ROLE_STATE.ST_RUSH] = function(roleSpr)
		roleSpr:ResumeAni()
	end,
	[ROLE_STATE.ST_DIE] = function(roleSpr)
		roleSpr:ResumeAni()
	end,
}
function clsRoleSpr:OnExitState(oState)
	local func = MAP_STATE_EXIT[oState:GetUid()]
	if func then func(self) end
end


-------------------------
-- 测试方法
-------------------------
--测试击退
function clsRoleSpr:TestHitBack()
	self:Turn2ActState(ROLE_STATE.ST_HIT)
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVLINE, {
		["movDir"] = (self:GetCurDir()+math.pi)%(math.pi*2),
		["movFrame"] = 5,
		["movSpeed"] = 15,
	})
end

--测试浮空
function clsRoleSpr:TestHitFloat()
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVREST)
	self:Turn2ActState(ROLE_STATE.ST_FLIGHT)
	self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVLINE, {["jmpSpeed"] = const.FLIGHT_SPEED})
end

--测试冻结
function clsRoleSpr:TestFreeze()
	self:Turn2SkyMovState(ROLE_STATE.ST_SKYMOVFREEZE, {iFreeseTime=GAME_CONFIG.FPS})
	self:Turn2GrdMovState(ROLE_STATE.ST_GRDMOVFREEZE, {iFreeseTime=GAME_CONFIG.FPS})
	self:Turn2ActState(ROLE_STATE.ST_FREEZE, {iFreeseTime=GAME_CONFIG.FPS})
end

--测试受击
function clsRoleSpr:TestHit()
	self:Turn2ActState(ROLE_STATE.ST_HIT)
end

--测试死亡
function clsRoleSpr:TestDie()
	self:Turn2ActState(ROLE_STATE.ST_DIE)
end

--测试复活
function clsRoleSpr:TestRevive()
	self:Turn2ActState(ROLE_STATE.ST_REVIVE, {CurHP=self._entityObj:GetMaxHP()})
end
