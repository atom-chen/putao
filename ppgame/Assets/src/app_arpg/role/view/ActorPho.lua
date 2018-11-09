-----------------------
-- 职责：动作与换装
-- 3D模型
-----------------------
local BODY_SCALE = 0.2
local DTSCALE = 0.01
local BREATHTIME = 0.6

clsActorPho = class("clsActorPho", clsRoleBase)

function clsActorPho:ctor(parent, entityObj)
	clsRoleBase.ctor(self, parent, entityObj)
	
	self._tAllAnimation = {}
	self._bShowBody = true
	
	self._bodyRotation = {x=0,y=0,z=0}
	self._mBody = nil			--动画
	self.mShadowSpr = nil		--影子
	self.mBloodBar = nil		--血条
	self.mNameLabel = nil		--名字
	self.mCompPopSay = nil		--冒泡说话
	self._waitingFlyBlood = {}	--飘血动画
	
	self:SetShapeId(entityObj:GetShapeId())
	self:ShowShadow(true)
end

function clsActorPho:dtor()
	--self:_UnloadBody()
	KE_KillTimer(self._tmrAni)
end

--@每帧更新
function clsActorPho:FrameUpdate(deltaTime)
	
end

function clsActorPho:InitEventListeners()
	clsRoleBase.InitEventListeners(self)
	self._entityObj:AddListener(self, "ShapeId", self.OnShapeId, self)
	self._entityObj:AddListener(self, "POP_SAY", self.PopSay, self)
	self._entityObj:AddListener(self, "Nick", self.SetName, self, true)
end

function clsActorPho:OnShapeId(Value, old_value)
	self:_UnloadBody()
	self:_LoadBody()
end

function clsActorPho:_LoadBody()
	if not self._entityObj:GetShapeId() then return end
	if self._mBody then return end
	local respath = string.format( "res/rolePho/%s.png", self._entityObj:GetShapeId() )
	self._mBody = cc.Sprite:create(respath) or cc.Sprite:create("res/rolePho/00020604_1.png")
	self._mBody:setScale(BODY_SCALE)
	self._mBody:setAnchorPoint(cc.p(0.5,0))
	self:addChild(self._mBody)
--	self._mBody.runAction = function() assert(false) end
end

function clsActorPho:_UnloadBody()
	if self._mBody then 
		KE_SafeDelete(self._mBody) 
		self._mBody = nil 
	end
end

function clsActorPho:ShowBody(bShow)
	if self._bShowBody == bShow then return end
	self._bShowBody = bShow
	if bShow then
		self:_LoadBody()
		self._mBody:setVisible(true)
	else
		if self._mBody then
			self._mBody:setVisible(false)
		end
	end
end

---------------------------
-- 换装部分
---------------------------
function clsActorPho:SetShapeId(iShapeId)
	self._entityObj:SetShapeId(iShapeId)
end

function clsActorPho:SetEquipment(equip_info)
	assert(is_table(equip_info) or equip_info==nil)
end

---------------------------
-- 动作部分
---------------------------
function clsActorPho:PlayAni(sAniKey, iLoop, Callback)
	assert(const.ANINAME[sAniKey], "Error: 无效的动作名: "..sAniKey)
	if self.sAniKey == sAniKey then 
	--	logger.error("当前已经在播放该动作：",sAniKey)
		return false
	end
	self.sAniKey = sAniKey
	
	if self._mBody._act_ani then self._mBody:stopAction(self._mBody._act_ani) end
	iLoop = iLoop or -1
	local once = cc.Sequence:create( cc.ScaleTo:create(BREATHTIME,BODY_SCALE+DTSCALE,BODY_SCALE+DTSCALE), cc.ScaleTo:create(BREATHTIME,BODY_SCALE,BODY_SCALE), cc.DelayTime:create(0.3) )
	if iLoop < 1 then 
		self._mBody._act_ani = self._mBody:runAction(cc.RepeatForever:create(once))
		if Callback then Callback() end 
	elseif iLoop == 1 then 
		self._mBody._act_ani = self._mBody:runAction(cc.Sequence:create(
												cc.ScaleTo:create(BREATHTIME,BODY_SCALE+DTSCALE,BODY_SCALE+DTSCALE), 
												cc.ScaleTo:create(BREATHTIME,BODY_SCALE,BODY_SCALE), 
												cc.CallFunc:create(function() if Callback then Callback() end  end) 
												))
	elseif iLoop > 1 then
		self._mBody._act_ani = self._mBody:runAction(cc.Sequence:create(
												cc.Repeat:create(once, iLoop), 
												cc.CallFunc:create(function() if Callback then Callback() end  end) 
												))
	end 
	return true 
end

function clsActorPho:PauseAni(iFrame)
--	assert(false, "尚未实现")
end

function clsActorPho:ResumeAni(iFrame)
--	assert(false, "尚未实现")
end

function clsActorPho:GetAni()
	return self.sAniKey
end

----------------------------
-- 物理性质
----------------------------
function clsActorPho:OnCurDir(Value, old_value)
--	self._bodyRotation.y = math.deg(Value)+90
--	self._mBody:setRotation3D(self._bodyRotation)
end


----------------------------
-- 功能接口
----------------------------

--显示影子
local shadow_path = "res/role3d/shadow.png"
function clsActorPho:ShowShadow(bShow)
	if not bShow and not self.mShadowSpr then return end
	if not self.mShadowSpr then
		self.mShadowSpr = cc.Sprite:create(shadow_path)
		KE_SetParent(self.mShadowSpr, self)
	end
	self.mShadowSpr:setVisible(bShow)
end

--设置名字
local font_cfg = const.FONT_CFG(18)
function clsActorPho:SetName(sName,sOldName)
	if not sName or sName == "" then return end
	if not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(font_cfg, sName)
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetBodyHeight()+32)
	end
	self.mNameLabel:setString(sName)
end
function clsActorPho:ShowName(bShow)
	if self.mNameLabel then
		self.mNameLabel:setVisible(bShow)
	end
end
function clsActorPho:SetNameColor(color3b)
	if self.mNameLabel then 
		self.mNameLabel:setTextColor(color3b)
	end
end

--更新血条
function clsActorPho:RefleshBloodBar()
	if not self.mBloodBar then
		local bloodBg = cc.Sprite:create("res/uistu/fight/hpBg.png")
		self:addChild(bloodBg)
		bloodBg:setPosition(0,self:GetBodyHeight()+15)
		self.mBloodBar = ccui.LoadingBar:create("res/uistu/fight/hp_1.png", 0)
		local theProgBar = self.mBloodBar
		theProgBar:setDirection(ccui.LoadingBarDirection.LEFT)
		theProgBar:setPosition(0,self:GetBodyHeight()+15)
		self:addChild(theProgBar)
	end
	self.mBloodBar:setPercent(100*self._entityObj:GetCurHP()/self._entityObj:GetMaxHP())
end

-- 飘血动画
function clsActorPho:_PlayFlyBlood(Value)
	Value = math.ceil(Value)
	local sWords = string.format("%s%d", Value>0 and "+" or "", Value)
	local obj = cc.Label:createWithTTF(const.FONT_CFG(42), sWords)
	obj:setPosition(0,self:GetBodyHeight()+15)
	if Value > 0 then obj:setColor(const.COLOR.GREEN) else obj:setColor(const.COLOR.RED) end
	self:addChild(obj)
	obj:runAction(cc.Sequence:create(
		cc.MoveTo:create(0.12, cc.p(0,self:GetBodyHeight()+60)),
		cc.DelayTime:create(0.18),
		cc.CallFunc:create(function() 
			table.remove(self._waitingFlyBlood, 1)
			if self._waitingFlyBlood[1] then
				self:_PlayFlyBlood(self._waitingFlyBlood[1])
			end
		end),
		cc.DelayTime:create(0.12),
		cc.RemoveSelf:create()
	))
end
function clsActorPho:PlayFlyBlood(Value)
	table.insert(self._waitingFlyBlood, Value)
	if #self._waitingFlyBlood >= 2 then return end
	self:_PlayFlyBlood(self._waitingFlyBlood[1])
end

--冒泡说话
function clsActorPho:PopSay(sWords, OnCallback)
	if sWords == nil or sWords == "" then 
		if OnCallback then
			OnCallback()
		end
		return 
	end
	if not self.mCompPopSay then
		self.mCompPopSay = cc.Label:createWithTTF(const.FONT_CFG(), sWords)
		KE_SetParent(self.mCompPopSay, self)
	end
	
	self.mCompPopSay:stopAllActions()
	self.mCompPopSay:setString(sWords)
	self.mCompPopSay:setPosition(0,self:GetBodyHeight()+15)
	self.mCompPopSay:setScale(0.2)
	self.mCompPopSay:setVisible(true)
	self.mCompPopSay:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.ScaleTo:create(0.3, 1, 1),
			cc.MoveTo:create(0.3, cc.p(0,self:GetBodyHeight()+60))
		),
		cc.DelayTime:create(1),
		cc.CallFunc:create(function()
			self.mCompPopSay:setVisible(false)
			if OnCallback then
				OnCallback()
			end
		end)
	))
end
