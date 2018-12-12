-----------------------
-- 职责：动作与换装
-- 2D骨骼动画
-----------------------

local NAKED_SHAPE_ID = 11001
local BODY_SCALE = 0.12

clsActorArm = class("clsActorArm", clsRoleBase)

-- 构造函数
function clsActorArm:ctor(iShapeId)
	clsRoleBase.ctor(self)
	AddMemoryMonitor(self)
	
	self._mBody = nil			--动画
	self.mShadowSpr = nil		--影子
	self.mNameLabel = nil		--名字
	self.mCompPopSay = nil		--冒泡说话
	
	self:SetShapeId(iShapeId)
	self:ShowShadow(true)
end

--析构函数
function clsActorArm:dtor()
	self:_UnloadBody()
end

--@每帧更新
function clsActorArm:FrameUpdate(deltaTime)
	
end

function clsActorArm:_LoadBody()
	local resId	= self._ShapeId
	if not resId then return end
	if self._mBody then return end
	
	ClsResManager.GetInstance():AddArmatureFileInfo("role2d/10001/Cowboy.ExportJson")
	self._mBody = ccs.Armature:create("Cowboy")
	self._mBody:setAnchorPoint(cc.p(0.5,0))
	KE_SetParent(self._mBody, self)
	
	self._mBody:setScale(-BODY_SCALE, BODY_SCALE)
end

function clsActorArm:_UnloadBody()
	if not self._mBody then return end
	if self._mBody then KE_SafeDelete(self._mBody) self._mBody = nil end
	ClsResManager.GetInstance():SubArmatureFileInfo("role2d/10001/Cowboy.ExportJson")
end

---------------------------
-- 换装部分
---------------------------
function clsActorArm:SetShapeId(iShapeId)
	assert(is_number(iShapeId), "没有造型")
	if self._ShapeId == iShapeId then return end
	self._ShapeId = iShapeId
	self:_LoadBody()
end

function clsActorArm:SetEquipment(equip_info)
	assert(is_table(equip_info) or equip_info==nil)
end

---------------------------
-- 动作部分
---------------------------
function clsActorArm:PlayAni(sAniKey, iLoop, Callback)
	assert(const.ANINAME[sAniKey], "Error: 无效的动作名: "..sAniKey)
	if self.sAniKey == sAniKey then return end
	self.sAniKey = sAniKey
	iLoop = iLoop or 1
	
	self._mBody:getAnimation():play(sAniKey, 0, iLoop)
	
	local function onAnimationEvent(obj, evtName, aniName)
		if evtName == ccs.MovementEventType.loopComplete or evtName == ccs.MovementEventType.complete then
			self._mBody:getAnimation():setMovementEventCallFunc(function() end)
			Callback() 
		end
	end
	self._mBody:getAnimation():setMovementEventCallFunc(onAnimationEvent)
end

function clsActorArm:PauseAni(iFrame)
	iFrame = iFrame or 1
	self._mBody:getAnimation():gotoAndPause(iFrame)
end

function clsActorArm:ResumeAni(iFrame)
	iFrame = iFrame or 1
	self._mBody:getAnimation():gotoAndPlay(1)
end

function clsActorArm:GetAni()
	return self.sAniKey
end


----------------------------
-- 物理性质
----------------------------

function clsActorArm:OnCurDir(Value, old_value)
	local curDir8 = math.EightDir(Value)
	local needFlipX = (curDir8 == const.DIRECTION8.L or curDir8 == const.DIRECTION8.LU or curDir8 == const.DIRECTION8.LD)
	local xScale = needFlipX and BODY_SCALE or -BODY_SCALE
	self._mBody:setScale(xScale, BODY_SCALE)
end


----------------------------
-- 功能接口
----------------------------

function clsActorArm:GetNameLblH()
	return self:GetBodyHeight() + 15
end

--显示影子
function clsActorArm:ShowShadow(bShow)
	if not bShow and not self.mShadowSpr then return end
	if not self.mShadowSpr then
		self.mShadowSpr = cc.Sprite:create("role2d/shadow.png")
		KE_SetParent(self.mShadowSpr, self)
	end
	self.mShadowSpr:setVisible(bShow)
end

--设置名字
function clsActorArm:SetName(sName)
	if not sName or sName == "" then return end
	if not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(const.FONT_CFG(), sName)
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetNameLblH())
	end
	self.mNameLabel:setString(sName)
end

--显示名字
function clsActorArm:ShowName(bShow)
	if self.mNameLabel then
		self.mNameLabel:setVisible(bShow)
	end
end

--冒泡说话
function clsActorArm:PopSay(sWords, OnCallback)
	sWords = sWords or "我再说话你看到了吗？"
	if not self.mCompPopSay then
		self.mCompPopSay = cc.Label:createWithTTF(const.FONT_CFG(), sWords)
		KE_SetParent(self.mCompPopSay, self)
	end
	
	self.mCompPopSay:stopAllActions()
	self.mCompPopSay:setString(sWords)
	self.mCompPopSay:setPosition(0,self:GetNameLblH())
	self.mCompPopSay:setScale(0.2)
	self.mCompPopSay:setVisible(true)
	self.mCompPopSay:runAction(cc.Sequence:create(
		cc.Spawn:create(
			cc.ScaleTo:create(0.3, 1, 1),
			cc.MoveTo:create(0.3, cc.p(0,self:GetNameLblH()+30))
		),
		cc.DelayTime:create(0.5),
		cc.CallFunc:create(function()
			self.mCompPopSay:setVisible(false)
			
			if OnCallback then
				OnCallback()
			end
		end)
	))
end

function clsActorArm:StopSay()
	if self.mCompPopSay then
		self.mCompPopSay:stopAllActions()
		self.mCompPopSay:setVisible(false)
	end
end
