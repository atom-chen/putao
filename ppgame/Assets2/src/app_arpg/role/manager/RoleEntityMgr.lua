----------------------
-- 角色属性管理器
-- 注意CountryData CityData RoleData三者之间的同步
----------------------
ClsRoleEntityMgr = class("ClsRoleEntityMgr", clsCoreObject)
ClsRoleEntityMgr.__is_singleton = true

ClsRoleEntityMgr:RegisterEventType("update_role_data")

function ClsRoleEntityMgr:ctor()
	clsCoreObject.ctor(self)
	
	self._HeroId = nil
	self.tAllPlayerData = new_weak_table("v")
	self.tAllNpcData = new_weak_table("v")
	self.tAllMonsterData = new_weak_table("v")
	self.tAllTempData = new_weak_table("v")
	self.tAllData = {}
end

function ClsRoleEntityMgr:dtor()
	for _, data in pairs(self.tAllData) do
		KE_SafeDelete(data)
	end
	self.tAllData = nil
	self.tAllPlayerData = nil
	self.tAllNpcData = nil
	self.tAllMonsterData = nil
	self.tAllTempData = nil
end

function ClsRoleEntityMgr:IsRoleDead(role_id)
	local entityObj = self:GetRole(role_id)
	assert(entityObj, "不存在角色数据："..role_id)
	return entityObj:IsDead()
end

-- 私有接口，外部勿用
function ClsRoleEntityMgr:_update_role_data(iUid, Info)
	self.tAllData[iUid] = self.tAllData[iUid] or clsRoleFighter.new(iUid, Info.TypeId)
	self.tAllData[iUid]:BatchSetAttr(Info)
	self:FireEvent("update_role_data", iUid, self.tAllData[iUid])
	return self.tAllData[iUid]
end

function ClsRoleEntityMgr:UpdateFighter(Info)
	return self:_update_role_data(Info.Uid, Info)
end
-- 创建/更新
function ClsRoleEntityMgr:UpdateHero(Info)
	if self._HeroId == nil then self._HeroId = Info.Uid end
	if Info.Uid then assert(self._HeroId==Info.Uid) end
	self.tAllPlayerData[self._HeroId] = self:_update_role_data(self._HeroId, Info)
	self.tAllPlayerData[self._HeroId]:SetRoleType(const.ROLE_TYPE.TP_HERO)
	return self.tAllPlayerData[self._HeroId]
end
-- 创建/更新
function ClsRoleEntityMgr:UpdatePlayer(iUid, Info)
	self.tAllPlayerData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllPlayerData[iUid]:SetRoleType(const.ROLE_TYPE.TP_PLAYER)
	return self.tAllPlayerData[iUid]
end
-- 创建/更新
function ClsRoleEntityMgr:UpdateNpc(iUid, Info)
	self.tAllNpcData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllNpcData[iUid]:SetRoleType(const.ROLE_TYPE.TP_NPC)
	return self.tAllNpcData[iUid]
end
-- 创建/更新
function ClsRoleEntityMgr:UpdateMonster(iUid, Info)
	self.tAllMonsterData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllMonsterData[iUid]:SetRoleType(const.ROLE_TYPE.TP_MONSTER)
	return self.tAllMonsterData[iUid]
end
-- 创建/更新
function ClsRoleEntityMgr:UpdateTempData(iUid, Info)
	assert(iUid<0, "临时角色Uid需小于0")
	self.tAllTempData[iUid] = self:_update_role_data(iUid, Info)
	self.tAllTempData[iUid]:SetRoleType(const.ROLE_TYPE.TP_UNKNOWN)
	return self.tAllTempData[iUid]
end

-- 删除
function ClsRoleEntityMgr:DestroyRole(iUid)
	if self.tAllData[iUid] then
		KE_SafeDelete(self.tAllData[iUid])
		self.tAllData[iUid] = nil
	end
	self.tAllPlayerData[iUid] = nil
	self.tAllNpcData[iUid] = nil
	self.tAllMonsterData[iUid] = nil
	self.tAllTempData[iUid] = nil
end

----------------- getter ---------------------------

function ClsRoleEntityMgr:GetHeroId()
	return self._HeroId
end

function ClsRoleEntityMgr:GetHero()
	return self.tAllData[self._HeroId]
end

function ClsRoleEntityMgr:GetRole(iUid)
	return self.tAllData[iUid]
end
