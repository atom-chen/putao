-------------------
-- Buff管理
-------------------
module("fight", package.seeall)

local AUTO_BUFF_ID = 0

clsBuffData = class("clsBuffData", clsCoreObject)

clsBuffData:RegSaveVar("BuffType", TYPE_CHECKER.INT)			-- Buff类型
clsBuffData:RegSaveVar("BuffName", TYPE_CHECKER.STRING)		-- 命名
clsBuffData:RegSaveVar("Desc", TYPE_CHECKER.STRING)			-- 描述
clsBuffData:RegSaveVar("Icon", TYPE_CHECKER.STRING_NIL)		-- 图标
clsBuffData:RegSaveVar("PiaoZi", TYPE_CHECKER.STRING_NIL)		-- 飘字
clsBuffData:RegSaveVar("MutexDoTips", TYPE_CHECKER.BOOL)		-- 免疫是否提示

clsBuffData:RegSaveVar("MaxOverlap", TYPE_CHECKER.INT)			-- 最大堆叠数
clsBuffData:RegSaveVar("ReplaceAble", TYPE_CHECKER.BOOL)		-- 可否替换
clsBuffData:RegSaveVar("Prop", TYPE_CHECKER.STRING)			-- 影响的哪个属性
clsBuffData:RegSaveVar("Value", TYPE_CHECKER.INT)				-- 影响值
clsBuffData:RegSaveVar("Percent", TYPE_CHECKER.BOOL)			-- Value是否是指的百分比
clsBuffData:RegSaveVar("KeepTime", TYPE_CHECKER.INT)			-- 持续时间

function clsBuffData:ctor(BuffType, Owner, Placer)
	clsCoreObject.ctor(self)
	assert(Owner and Placer)
	AUTO_BUFF_ID = AUTO_BUFF_ID + 1
	self._autoId = AUTO_BUFF_ID
	self:SetBuffType(BuffType)
	self:InitByCfg()
	
	self.mOwner = Owner
	self.mPlacer = Placer
	self._finalValue = 0
	self._wishValue = 0
	self._birthRnd = 0
	self._firstApplyRnd = 0
end

function clsBuffData:dtor()
	
end

function clsBuffData:InitByCfg()
	local cfg = self:GetCfgInfo()
	for k, v in pairs(cfg) do 
		self:SetAttrSilent(k, table.clone(v))
	end
end

function clsBuffData:GetCfgInfo()
	return setting.T_buff[self:GetBuffType()]
end

--------------------------------------------------------

function clsBuffData:GetPid() return self._autoId end 

function clsBuffData:IsInValid()
	local KeepTime = self:GetKeepTime()
	if KeepTime == -1 then return false end
	return fight.FightService.GetInstance():GetCurRound() >= self._birthRnd + KeepTime - 1
end

function clsBuffData:GetBuffIcon()
	if self:GetKeepTime() == 0 then
		return nil
	end
	return self:GetIcon()
end

function clsBuffData:GetBuffPiaoZi()
	if self:GetBuffIcon() then
		return self:GetPiaoZi()
	end
end 

function clsBuffData:GetOwnerSpr()
	return ClsRoleSprMgr.GetInstance():GetRole(self.mOwner:GetUid())
end 

function clsBuffData:GetPlacerSpr()
	return ClsRoleSprMgr.GetInstance():GetRole(self.mPlacer:GetUid())
end 

function clsBuffData:ToFinalValue(propValue, propMin, propMax)
	if propMin and propMax then assert(propMin<=propMax) end 
	
	local WishValue = self:GetValue()
	if self:GetPercent() then
		WishValue = propValue * WishValue
	end
	local FinalValue = WishValue
	
	if propMin and propValue+FinalValue<propMin then
		FinalValue = propMin - propValue
	end
	if propMax and propValue+FinalValue>propMax then
		FinalValue = propMax - propValue
	end
	
	self._wishValue = WishValue
	self._finalValue = FinalValue
	
	return FinalValue
end

---------------------------------------------------------------

function clsBuffData:OnAdd()
	self._birthRnd = fight.FightService.GetInstance():GetCurRound()
	
	local theOwner = self.mOwner
	local BuffType = self:GetBuffType()
	
	if BuffType == 3001 or BuffType == 3002 then
		local propValue = theOwner:GetPhyAtk()
		local FinalValue = self:ToFinalValue( propValue, 1 )
		theOwner:SetBuffPhyAtk( theOwner:GetBuffPhyAtk() + FinalValue )
	elseif BuffType == 4001 or BuffType == 4002 then
		local propValue = theOwner:GetPhyDef()
		local FinalValue = self:ToFinalValue( propValue, 0 )
		theOwner:SetBuffPhyDef( theOwner:GetBuffPhyDef() + FinalValue )
	elseif BuffType == 2001 or BuffType == 2002 then
		local propValue = theOwner:GetMaxHP()
		local FinalValue = self:ToFinalValue( propValue, 100 )
		theOwner:AddMaxHP( FinalValue )
		if FinalValue > 0 then
			theOwner:AddHP(FinalValue)
		end
	elseif BuffType == 1001 then
		local propValue = theOwner:GetCurHP()
		local FinalValue = self:ToFinalValue( propValue, 0, theOwner:GetMaxHP() )
		theOwner:AddHP( FinalValue )
	end
	
	logger.fight( string.format("添加BUFF：%s WishValue=%.2f FinalValue=%.2f", self:GetBuffType(),self._wishValue,self._finalValue) )
end

function clsBuffData:OnDel()
	local theOwner = self.mOwner
	local BuffType = self:GetBuffType()
	
	if BuffType == 3001 or BuffType == 3002 then
		theOwner:SetBuffPhyAtk( theOwner:GetBuffPhyAtk() - self._finalValue )
	elseif BuffType == 4001 or BuffType == 4002 then
		theOwner:SetBuffPhyDef( theOwner:GetBuffPhyDef() - self._finalValue )
	elseif BuffType == 2001 or BuffType == 2002 then
		theOwner:AddMaxHP( theOwner:GetMaxHP() - self._finalValue )
	end
	
	logger.fight( string.format("移除BUFF：%s WishValue=%.2f FinalValue=%.2f", self:GetBuffType(),self._wishValue,self._finalValue) )
end

function clsBuffData:OnRoundBegin(Rnd)
	local theOwner = self.mOwner
	local BuffType = self:GetBuffType()
	
	if BuffType == 1002 then
		local propValue = theOwner:GetCurHP()
		local FinalValue = self:ToFinalValue( propValue, 0, theOwner:GetMaxHP() )
		theOwner:AddHP( FinalValue )
	end
end

function clsBuffData:OnRoundEnd(Rnd)
	local theOwner = self.mOwner
	local BuffType = self:GetBuffType()
	
	if BuffType == 1003 then
		local propValue = theOwner:GetCurHP()
		local FinalValue = self:ToFinalValue( propValue, 0, theOwner:GetMaxHP() )
		theOwner:AddHP( FinalValue )
	end
end

function clsBuffData:OnDead()
	
end

function clsBuffData:OnBeforeHit()
	
end

function clsBuffData:OnAfterHit()
	
end

function clsBuffData:OnBeforeAttack()
	
end

function clsBuffData:OnAfterAttack()

end

function clsBuffData:OnFixHurtValue(Attacker, iHurtValue)
--	local theOwner = self.mOwner
	local BuffType = self:GetBuffType()
	
	if BuffType == 5001 then
		local FinalValue = self:GetValue()
		if self:GetPercent() then
			FinalValue = iHurtValue * FinalValue
		end
		iHurtValue = iHurtValue + FinalValue
	elseif BuffType == 5002 then
		if iHurtValue > 1 then
			iHurtValue = 1
		end
	end
	
	return iHurtValue
end
