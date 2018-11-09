-----------------------
-- 职责：动作与换装
-- 序列帧动画
-----------------------
clsActorSeq = class("clsActorSeq", clsRoleBase)

-- 构造函数
function clsActorSeq:ctor(iShapeId)
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
function clsActorSeq:dtor()
	self.body = nil
end

--@每帧更新
function clsActorSeq:FrameUpdate(deltaTime)
	
end

-- 刷新外观（影响因素：套装 + 方向 + 动作）
function clsActorSeq:_RefreshAppearance()
	local dir8 = math.EightDir(self:GetCurDir())
	local aniKey = self.sAniKey
	local resId	= self._ShapeId
	if not resId then return end
	
	local ani = self:_loadAnimate(resId, aniKey, dir8)
	if not ani then return end
	
	self._mBody:setFlippedX(dir8>4)
	self._mBody:stopAllActions()
	self._mBody:runAction(ani)
end

function clsActorSeq:_LoadBody()
	if self._mBody then logger.warn("已经_LoadBody过") return end
	self._mBody = cc.Sprite:create()
	KE_SetParent(self._mBody, self)
end

function clsActorSeq:_UnloadBody()
	if not self._mBody then return end
	if self._mBody then KE_SafeDelete(self._mBody) self._mBody = nil end
end

function clsActorSeq:ShowBody(bShow)
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

---------------------------------------------
-- 换装部分 -->
---------------------------------------------
function clsActorSeq:SetShapeId(iShapeId)
	assert(is_number(iShapeId), "没有造型")
	if self._ShapeId == iShapeId then return end
	
	for i=0,2 do
		ClsResManager.GetInstance():SubSpriteFrames( string.format("res/role2d/%s%d.plist",self._ShapeId,i) )
	end
	
	self._ShapeId = iShapeId
	self:_LoadBody()
	
	for i=0, 2 do
		ClsResManager.GetInstance():AddSpriteFrames( string.format("res/role2d/%s%d.plist",self._ShapeId,i) )
	end
	
	self:_RefreshAppearance()
end

function clsActorSeq:SetEquipment(equip_info)
	assert(is_table(equip_info) or equip_info==nil)
end

---------------------------------------------
-- 动作部分 -->
---------------------------------------------

local function NewAnimate(iShapeId, sAniKey, dir8)
	local aniFrames = {}
	local frameIdx = 0
	local dirKey = dir8 
	if (dir8 > 4) then dirKey = 8 - dir8 end
	while true do
		local frameName = string.format("%d_%s_d%d_%d.png", iShapeId, sAniKey, dirKey, frameIdx)
	    local spriteFrame = cc.SpriteFrameCache:getInstance():getSpriteFrame(frameName)
		if not spriteFrame then break end
		table.insert(aniFrames, spriteFrame)
		frameIdx = frameIdx + 1
	end
	
	local _animation = cc.Animation:createWithSpriteFrames(aniFrames, 0.05)
	local _animation = cc.Animate:create(_animation)
   	return _animation
end

function clsActorSeq:_loadAnimate(iShapeId, sAniKey, dir8)
	if not iShapeId or not sAniKey or not dir8 then return end
	
	local avatarKey = string.format("%d_%s_%d", iShapeId, sAniKey, dir8)
	if self._sAvatarKey == avatarKey then return end
	self._sAvatarKey = avatarKey
	
	local ani = NewAnimate(iShapeId, sAniKey, dir8)
	assert(ani, "加载动作失败: "..sAniKey)
	
	return ani
end

function clsActorSeq:PlayAni(sAniKey, iLoop, Callback)
	if self.sAniKey == sAniKey then return end
	self.sAniKey = sAniKey
	self:_RefreshAppearance()
end

function clsActorSeq:PauseAni(iFrame)
	
end

function clsActorSeq:ResumeAni(iFrame)
	
end

-- 获取动作Key
function clsActorSeq:GetAni()
	return self.sAniKey
end

----------------------------
-- 物理性质
----------------------------

function clsActorSeq:OnCurDir(Value, old_value)
	if math.EightDir(old_value) ~= math.EightDir(Value) then 
		self:_RefreshAppearance() 
	end
end

----------------------------
-- 功能接口
----------------------------

function clsActorSeq:GetNameLblH()
	return self:GetBodyHeight() + 15
end

--显示影子
function clsActorSeq:ShowShadow(bShow)
	if not self.mShadowSpr then
		self.mShadowSpr = cc.Sprite:create("res/role2d/shadow.png")
		KE_SetParent(self.mShadowSpr, self)
	end
	self.mShadowSpr:setVisible(bShow)
end

--设置名字
function clsActorSeq:SetName(sName)
	sName = sName or "滴滴滴"
	if not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(const.FONT_CFG(), sName)
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetNameLblH())
	end
	self.mNameLabel:setString(sName)
end

--显示名字
function clsActorSeq:ShowName(bShow)
	if bShow and not self.mNameLabel then
		self.mNameLabel = cc.Label:createWithTTF(const.FONT_CFG(), "滴滴滴")
		KE_SetParent(self.mNameLabel, self)
		self.mNameLabel:setPosition(0,self:GetNameLblH())
	end
	if self.mNameLabel then
		self.mNameLabel:setVisible(bShow)
	end
end

--冒泡说话
function clsActorSeq:PopSay(sWords, OnCallback)
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

function clsActorSeq:StopSay()
	if self.mCompPopSay then
		self.mCompPopSay:stopAllActions()
		self.mCompPopSay:setVisible(false)
	end
end
