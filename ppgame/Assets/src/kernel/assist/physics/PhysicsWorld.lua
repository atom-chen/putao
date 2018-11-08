-------------------------
-- 碰撞检测系统
-------------------------
module("phys", package.seeall)

local function hasPair(grpPairs, grpA, grpB)
	for _, peer in ipairs(grpPairs) do 
		if peer[1] == grpA and peer[2] == grpB then
			return true
		elseif peer[1] == grpB and peer[2] == grpA then
			return true
		end
	end
	return false
end

ClsPhysicsWorld = class("ClsPhysicsWorld", grp.clsIGroupMgr)
ClsPhysicsWorld.__is_singleton = true

function ClsPhysicsWorld:ctor()
	grp.clsIGroupMgr.ctor(self)
	self._check_pairs = {}
	self:_init_listeners()
end

function ClsPhysicsWorld:dtor()
	g_EventMgr:DelListener(self)
	ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
end

--@每帧更新
function ClsPhysicsWorld:FrameUpdate(deltaTime)
	self:DoCollisionTest()
end

--@override
function ClsPhysicsWorld:CreateGroup(grp_id)
	self.tAllGroups[grp_id] = self.tAllGroups[grp_id] or clsPhysGroup.new(grp_id)
	return self.tAllGroups[grp_id]
end
--@override
function ClsPhysicsWorld:SetGroupRelation(grp_1, grp_2, relation)
	grp.clsIGroupMgr.SetGroupRelation(self, grp_1, grp_2, relation)
	
	self._check_pairs = {}
	for _, GroupA in pairs(self.tAllGroups) do
		local enemy_grp_list = GroupA:GetEnemyList() or {}
		for _, GroupB in pairs(enemy_grp_list) do
			if not hasPair(self._check_pairs, GroupA, GroupB) then
				table.insert(self._check_pairs, {GroupA, GroupB})
			end
		end
	end
end

function ClsPhysicsWorld:AddBody(body, grp_id)
	if body==nil then return end
	local grp = self:GetGroup(grp_id)
	grp:AddMember(body)
end

function ClsPhysicsWorld:RemoveBody(body)
	if body==nil then return end
	for _, grp in pairs(self.tAllGroups) do
		grp:RemoveMember(body)
	end
end

----------------------------
-- 碰撞检测相关
----------------------------
local math_abs = math.abs
local math_min = math.min

local func_table = {
	["Rect"] = {
		["Rect"] 	= math.RectAndRect,
		["Circle"] 	= math.RectAndCircle,
	},
	["Circle"] = {
		["Rect"] 	= math.CircleAndRect,
		["Circle"] 	= math.CircleAndCircle,
	},
}

local function TestAABB(obj1, obj2)
	local disH = (obj1:GetPosY()+obj1:GetPosH()) - (obj2:GetPosY()+obj2:GetPosH())
	local minBodyH = disH>0 and obj2:GetBodyHeight() or obj1:GetBodyHeight()
	if math_abs(disH) > minBodyH then
		return false 
	end
	local shapeInfo1 = obj1:GetShapeInfo()
	local shapeInfo2 = obj2:GetShapeInfo()
	return func_table[shapeInfo1.sShapeType][shapeInfo2.sShapeType](shapeInfo1.tShapeDesc,shapeInfo2.tShapeDesc)
end

function ClsPhysicsWorld:DoCollisionTest()
	for _, peer in ipairs(self._check_pairs) do 
		local members_1 = peer[1]:GetMemberList()
		local members_2 = peer[2]:GetMemberList()
		for obj_1, _ in pairs(members_1) do
			for obj_2, _ in pairs(members_2) do
				if TestAABB(obj_1, obj_2) then
					obj_1:OnCollision(obj_2)
					obj_2:OnCollision(obj_1)
				end
			end
		end
	end
end

------------------------------------------------------------

function ClsPhysicsWorld:DumpDebugInfo()
	for grpID, grp in pairs(self.tAllGroups) do
		logger.printf("GroupId=%d  MemberCnt=%d  EnemyCnt=%d  PartnerCnt=%d", 
			     grpID, 
			     table.size(grp:GetMemberList()), table.size(grp:GetEnemyList()), table.size(grp:GetPartnerList()) )
	end
end

function ClsPhysicsWorld:_init_listeners()
	g_EventMgr:AddListener(self, "START_COMBAT", function(thisObj)
		local combatType = fight.FightService.GetInstance():GetCombatType()
		if combatType == const.COMBAT_TYPE.Instant then
			ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_PHYSICS)
		elseif combatType == const.COMBAT_TYPE.Round then
			ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
		elseif combatType == const.COMBAT_TYPE.Post then
			ClsUpdator.GetInstance():RegisterUpdator(self.FrameUpdate, self, ClsUpdator.ORDER_PHYSICS)
		end
	end)
	g_EventMgr:AddListener(self, "END_COMBAT", function(thisObj)
		local combatType = fight.FightService.GetInstance():GetCombatType()
		if combatType == const.COMBAT_TYPE.Instant then
			ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
		elseif combatType == const.COMBAT_TYPE.Round then
			ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
		elseif combatType == const.COMBAT_TYPE.Post then
			ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
		end
	end)
	g_EventMgr:AddListener(self, "LOGOUT", function(thisObj)
		ClsUpdator.GetInstance():UnregisterUpdator(self.FrameUpdate, self)
	end)
	--
	g_EventMgr:AddListener(self, "NEW_TEAM", function(thisObj, team_id, oTeam)
		if fight.FightService.GetInstance():GetCombatType() == const.COMBAT_TYPE.Round then return end
		self:CreateGroup(team_id)
		self:CreateGroup(-team_id)
	end)
	g_EventMgr:AddListener(self, "DEL_TEAM", function(thisObj, team_id)
		if fight.FightService.GetInstance():GetCombatType() == const.COMBAT_TYPE.Round then return end
		self:RemoveGroup(team_id)
		self:RemoveGroup(-team_id)
	end)
	g_EventMgr:AddListener(self, "TEAM_RELATION_CHG", function(thisObj, team_1, team_2, relation)
		if fight.FightService.GetInstance():GetCombatType() == const.COMBAT_TYPE.Round then return end
		self:SetGroupRelation(team_1, team_2, relation)
		local teamId1 = team_1
		if type(team_1) ~= "number" then teamId1 = team_1:GetUid() end
		local teamId2 = team_2
		if type(team_2) ~= "number" then teamId2 = team_2:GetUid() end
		teamId1 = -teamId1
		teamId2 = -teamId2
		self:SetGroupRelation(teamId1, team_2, relation)
		self:SetGroupRelation(team_1, teamId2, relation)
	end)
	g_EventMgr:AddListener(self, "TEAM_ADD_MEMBER", function(thisObj, team_id, obj)
		if fight.FightService.GetInstance():GetCombatType() == const.COMBAT_TYPE.Round then return end
		self:AddBody(obj, team_id)
	end)
	g_EventMgr:AddListener(self, "TEAM_DEL_MEMBER", function(thisObj, team_id, obj)
		if fight.FightService.GetInstance():GetCombatType() == const.COMBAT_TYPE.Round then return end
		self:RemoveBody(obj)
	end)
end
