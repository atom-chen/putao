-------------------
-- Buff管理
-------------------
module("fight", package.seeall)

clsBuffMgr = class("clsBuffMgr", clsCoreObject)
clsBuffMgr:RegisterEventType("add_buff")
clsBuffMgr:RegisterEventType("del_buff")

function clsBuffMgr:ctor(Owner)
	assert(Owner, "未设置Buff所属角色")
	clsCoreObject.ctor(self)
	self.mOwner = Owner
	self.tBuffList = {}
end

function clsBuffMgr:dtor()
	self:ClearBuff()
end

function clsBuffMgr:FrameUpdate(deltaTime)
	
end

function clsBuffMgr:GetOwner()
	return self.mOwner
end

function clsBuffMgr:GetBuffList()
	return self.tBuffList
end

function clsBuffMgr:GetBuffCountByType(BuffType)
	local cnt = 0
	for _, buff in ipairs(self.tBuffList) do 
		if buff:GetBuffType() == BuffType then
			cnt = cnt + 1
		end
	end
	return cnt
end

function clsBuffMgr:GetFirstBuffByType(BuffType)
	for _, buff in ipairs(self.tBuffList) do 
		if buff:GetBuffType() == BuffType then
			return buff 
		end
	end
	return nil
end

--------------------------------------------------------------

function clsBuffMgr:AddBuff(Placer, BuffType)
	--检查是否被排斥
	local RejectBuffs = setting.T_buff_mutex[BuffType]
	if RejectBuffs then
		for _, OtherType in ipairs(RejectBuffs) do
			if self:HasBuffOfType(OtherType) then
				local OtherBuffCfg = setting.T_buff[OtherType]
				if OtherBuffCfg.MutexDoTips then
					self.mOwner:DoSay(string.format("免疫%s",BuffName))
				end
				logger.normal("添加BUFF失败：被排斥");
				return nil
			end
		end
	end
	
	local BuffInfo = setting.T_buff[BuffType]
	
	--检查堆叠上限，MaxOverlap为-1表示无限叠加
	if BuffInfo.MaxOverlap < 0 or self:GetBuffCountByType(BuffType) < BuffInfo.MaxOverlap then  
		local buffObj = clsBuffData.new(BuffType, self.mOwner, Placer)
		table.insert(self.tBuffList, buffObj)
		buffObj:OnAdd()
		self:FireEvent("add_buff", buffObj)
		return buffObj
	end
	
	--检查是否可替换
	if BuffInfo.ReplaceAble then
		local firstBuff = self:GetFirstBuffByType(BuffType)
		if firstBuff then
			self:DelBuff(firstBuff)
			local buffObj = clsBuffData.new(BuffType, self.mOwner, Placer)
			table.insert(self.tBuffList, buffObj)
			buffObj:OnAdd()
			self:FireEvent("add_buff", buffObj)
			return buffObj
		end
	end
	
	return nil 
end

function clsBuffMgr:DelBuff(buffObj)
	table.remove_array_element(self.tBuffList, buffObj)
	buffObj:OnDel()
	self:FireEvent("del_buff", buffObj)
end

function clsBuffMgr:ClearBuff()
	local cnt = #self.tBuffList
	for i=cnt, 1, -1 do
		self:DelBuff(self.tBuffList[i])
	end
end

function clsBuffMgr:ClearInvalidBuff()
	local cnt = #self.tBuffList
	for i=cnt, 1, -1 do
		if self.tBuffList[i]:IsInValid() then
			self:DelBuff(self.tBuffList[i])
		end
	end
end

--------------------------------------------------------------

function clsBuffMgr:OnStartCombat()
	self:ClearBuff()
end

function clsBuffMgr:OnEndCombat()
	self:ClearBuff()
end

function clsBuffMgr:OnRoundBegin(Rnd)
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnRoundBegin(Rnd)
	end
end

function clsBuffMgr:OnRoundEnd(Rnd)
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnRoundEnd(Rnd)
	end
	self:ClearInvalidBuff()
end

function clsBuffMgr:OnBeforeHit()
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnBeforeHit()
	end
end

function clsBuffMgr:OnAfterHit()
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnAfterHit()
	end
end

function clsBuffMgr:OnBeforeAttack()
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnBeforeAttack()
	end
end

function clsBuffMgr:OnAfterAttack()
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnAfterAttack()
	end
end

function clsBuffMgr:OnFixHurtValue(Attacker, iHurtValue)
	for _, buffObj in ipairs(self.tBuffList) do 
		iHurtValue = buffObj:OnFixHurtValue(Attacker, iHurtValue)
	end
	return iHurtValue
end

function clsBuffMgr:OnDead()
	for _, buffObj in ipairs(self.tBuffList) do 
		buffObj:OnDead()
	end
	self:ClearBuff()
end
