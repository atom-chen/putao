--------------------
-- 角色管理器
--------------------
ClsRoleSprMgr = class("ClsRoleSprMgr")
ClsRoleSprMgr.__is_singleton = true

function ClsRoleSprMgr:ctor()
	self.tAllPlayer = {}		--所有玩家
	self.tAllNpc = {}			--所有NPC
	self.tAllMonster = {}		--所有怪物
	self.tAllTempRole = new_weak_table("k")		--所有临时角色
	
	g_EventMgr:AddListener("ClsRoleSprMgr", "LEAVE_WORLD", function(thisObj) 
		self:DestroyAllPlayer()
		self:DestroyAllNpc()
		self:DestroyAllMonster()
		self:DestroyAllTempRole()
	end)
end

function ClsRoleSprMgr:dtor()
	g_EventMgr:DelListener("ClsRoleSprMgr")
	self:DestroyAllPlayer()
	self:DestroyAllNpc()
	self:DestroyAllMonster()
	self:DestroyAllTempRole()
end

--------------分割线----------------------------

-- 创建临时角色
function ClsRoleSprMgr:CreateTempRole(TypeId)
	g_tmprole_id = g_tmprole_id or 0
	g_tmprole_id = g_tmprole_id - 1
	ClsRoleEntityMgr.GetInstance():UpdateTempData(g_tmprole_id, {TypeId=TypeId})
	local tmpRole = clsRoleSpr.new(g_tmprole_id)
	self.tAllTempRole[tmpRole] = true
	return tmpRole
end

-- 销毁临时角色
function ClsRoleSprMgr:DestroyTempRole(tmpRole)
	if self.tAllTempRole[tmpRole] then
		self.tAllTempRole[tmpRole] = nil
		KE_SafeDelete(tmpRole)
	end
end

-- 销毁所有临时角色
function ClsRoleSprMgr:DestroyAllTempRole()
	for tmpRole, _ in pairs(self.tAllTempRole) do
		KE_SafeDelete(tmpRole)
	end
	self.tAllTempRole = {}
end

--------------分割线----------------------------

function ClsRoleSprMgr:CreateHero()
	local iHeroId = ClsRoleEntityMgr.GetInstance():GetHeroId()
	assert(ClsRoleEntityMgr.GetInstance():GetRole(iHeroId), "角色数据丢失: "..iHeroId)
	if self.tAllPlayer[iHeroId] then return self.tAllPlayer[iHeroId] end
	
	self.tAllPlayer[iHeroId] = clsHeroSpr.new(iHeroId)
	return self.tAllPlayer[iHeroId]
end

function ClsRoleSprMgr:CreatePlayer(iUid)
	assert(ClsRoleEntityMgr.GetInstance():GetRole(iUid), "角色数据丢失: "..iUid)
	if self.tAllPlayer[iUid] then return self.tAllPlayer[iUid] end
	
	self.tAllPlayer[iUid] = clsPlayerSpr.new(iUid)
	return self.tAllPlayer[iUid]
end

function ClsRoleSprMgr:CreateNpc(iUid)
	assert(ClsRoleEntityMgr.GetInstance():GetRole(iUid), "角色数据丢失: "..iUid)
	if self.tAllNpc[iUid] then return self.tAllNpc[iUid] end
	
	self.tAllNpc[iUid] = clsNpcSpr.new(iUid)
	return self.tAllNpc[iUid]
end

function ClsRoleSprMgr:CreateMonster(iUid)
	assert(ClsRoleEntityMgr.GetInstance():GetRole(iUid), "角色数据丢失: "..iUid)
	if self.tAllMonster[iUid] then return self.tAllMonster[iUid] end
	
	self.tAllMonster[iUid] = clsMonsterSpr.new(iUid)
	return self.tAllMonster[iUid]
end

function ClsRoleSprMgr:CreateRole(iUid)
	local RoleData = ClsRoleEntityMgr.GetInstance():GetRole(iUid)
	assert(RoleData, "角色数据丢失："..iUid)
	if not RoleData then return end
	
	local roleType = RoleData:GetRoleType()
	
	if roleType == const.ROLE_TYPE.TP_HERO then
		assert(iUid==ClsRoleEntityMgr.GetInstance():GetHeroId())
		return self:CreateHero()
	elseif roleType == const.ROLE_TYPE.TP_PLAYER then
		return self:CreatePlayer(iUid)
	elseif roleType == const.ROLE_TYPE.TP_MONSTER then
		return self:CreateMonster(iUid)
	elseif roleType == const.ROLE_TYPE.TP_NPC then
		return self:CreateNpc(iUid)
	else 
		logger.error("未知的角色类型：", iUid, roleType)
		assert(false, "未知角色类型")
	end
end

---------------------------------

function ClsRoleSprMgr:DestroyHero()
	self:DestroyPlayer(ClsRoleEntityMgr.GetInstance():GetHeroId())
end

function ClsRoleSprMgr:DestroyPlayer(iUid)
	if self.tAllPlayer[iUid] then
		KE_SafeDelete(self.tAllPlayer[iUid])
		self.tAllPlayer[iUid] = nil
	end
end

function ClsRoleSprMgr:DestroyNpc(iUid)
	if self.tAllNpc[iUid] then
		KE_SafeDelete(self.tAllNpc[iUid])
		self.tAllNpc[iUid] = nil
	end
end

function ClsRoleSprMgr:DestroyMonster(iUid)
	if self.tAllMonster[iUid] then
		KE_SafeDelete(self.tAllMonster[iUid])
		self.tAllMonster[iUid] = nil
	end
end

function ClsRoleSprMgr:DestroyRole(iUid)
	if self.tAllMonster[iUid] then
		self:DestroyMonster(iUid)
	elseif self.tAllPlayer[iUid] then
		self:DestroyPlayer(iUid)
	elseif self.tAllNpc[iUid] then
		self:DestroyNpc(iUid)
	end
end

function ClsRoleSprMgr:DestroyAllPlayer()
	for iUid, obj in pairs(self.tAllPlayer) do
		KE_SafeDelete(self.tAllPlayer[iUid])
	end
	self.tAllPlayer = {}
end

function ClsRoleSprMgr:DestroyAllNpc()
	for iUid, obj in pairs(self.tAllNpc) do
		KE_SafeDelete(self.tAllNpc[iUid])
	end
	self.tAllNpc = {}
end

function ClsRoleSprMgr:DestroyAllMonster()
	for iUid, obj in pairs(self.tAllMonster) do
		KE_SafeDelete(self.tAllMonster[iUid])
	end
	self.tAllMonster = {}
end

-----------------------------

function ClsRoleSprMgr:ShowAllMonster(bShow)
	if self._bShowAllMonster == bShow then return end
	self._bShowAllMonster = bShow
	for iUid, obj in pairs(self.tAllMonster) do
		obj:ShowBody(bShow)
	end
end

function ClsRoleSprMgr:ShowAllNpc(bShow)
	if self._bShowAllNpc == bShow then return end
	self._bShowAllNpc = bShow
	for iUid, obj in pairs(self.tAllNpc) do
		obj:ShowBody(bShow)
	end
end

function ClsRoleSprMgr:ShowAllPlayer(bShow)
	if self._bShowAllPlayer == bShow then return end
	self._bShowAllPlayer = bShow
	for iUid, obj in pairs(self.tAllPlayer) do
		obj:ShowBody(bShow)
	end
	if self:GetHero() then
		self:GetHero():ShowBody(true)
	end
end

function ClsRoleSprMgr:IsShowMonster() return self._bShowAllMonster end
function ClsRoleSprMgr:IsShowNpc() return self._bShowAllNpc end
function ClsRoleSprMgr:IsShowPlayer() return self._bShowAllPlayer end

-----------------------------

function ClsRoleSprMgr:GetRole(iUid)
	return self.tAllPlayer[iUid] or self.tAllNpc[iUid] or self.tAllMonster[iUid] or nil
end
function ClsRoleSprMgr:GetHero() return self.tAllPlayer[ClsRoleEntityMgr.GetInstance():GetHeroId()] end
function ClsRoleSprMgr:GetPlayer(iUid) return self.tAllPlayer[iUid] end
function ClsRoleSprMgr:GetNpc(iUid) return self.tAllNpc[iUid] end
function ClsRoleSprMgr:GetMonster(iUid) return self.tAllMonster[iUid] end
