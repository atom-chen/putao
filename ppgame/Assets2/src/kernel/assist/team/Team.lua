-------------------
-- 战斗分组 FightTeam
-------------------
clsTeam = class("clsTeam", grp.clsIGroup)

function clsTeam:ctor(team_id)
	grp.clsIGroup.ctor(self, team_id)
	self.tMemberList = {}
	self.iLeaderId = nil	--队长ID
end

function clsTeam:dtor()
	self:ClearMemberList()
end

function clsTeam:GetMemberList()
	return self.tMemberList
end

function clsTeam:GetMemberPos(destObj)
	for i, obj in ipairs(self.tMemberList) do
		if obj == destObj then 
			return i 
		end
	end
	return nil
end

function clsTeam:GetMemberCount()
	return #self.tMemberList
end

function clsTeam:ClearMemberList()
	local cnt = #self.tMemberList 
	for i=cnt, 1, -1 do
		self:RemoveMemberByPos(i)
	end
	self.tMemberList = {}
end

function clsTeam:AddMember(obj)
	if self:GetMemberPos(obj) then
		logger.warn("已经添加过该成员", obj)
		return
	end
	table.insert(self.tMemberList, obj)
	self:OnAddMember(obj)			--【NOTE:】 成功添加进了群组时回调
end

function clsTeam:RemoveMemberByPos(pos)
	if pos and self.tMemberList[pos] then
		local obj = table.remove(self.tMemberList, pos)
		self:OnRemoveMember(obj)	--【NOTE:】 从群组移除时回调
	end
end

function clsTeam:RemoveMember(obj)
	local pos = self:GetMemberPos(obj)
	if pos then
		table.remove(self.tMemberList, pos)
		self:OnRemoveMember(obj)	--【NOTE:】 从群组移除时回调
	end
end

function clsTeam:OnAddMember(obj)
	obj:OnAddtoTeam(self)
	g_EventMgr:FireEvent("TEAM_ADD_MEMBER", self:GetUid(), obj)
end

function clsTeam:OnRemoveMember(obj)
	obj:OnRemoveFromTeam(self)
	g_EventMgr:FireEvent("TEAM_DEL_MEMBER", self:GetUid(), obj)
end


function clsTeam:SetLeaderId(leader_id)
	self.iLeaderId = leader_id
end

function clsTeam:GetLeaderId()
	return self.iLeaderId
end

-------------------------------------------------------------

function clsTeam:IsAllDie()
	local memberList = self.tMemberList
	for _, obj in ipairs(memberList) do 
		if obj:IsAlive() then return false end 
	end 
	return true 
end 

function clsTeam:GetTotalHP()
	local total = 0
	local memberList = self.tMemberList
	for _, obj in ipairs(memberList) do 
		total = total + obj:GetCurHP()
	end 
	return total
end 

function clsTeam:GetTotalMaxHP()
	local total = 0
	local memberList = self.tMemberList
	for _, obj in ipairs(memberList) do 
		total = total + obj:GetMaxHP()
	end 
	return total
end 

function clsTeam:GetHpPercent()
	local totalHp = 0
	local totalMaxHp = 0
	local memberList = self.tMemberList
	for _, obj in ipairs(memberList) do 
		totalHp = totalHp + obj:GetCurHP()
		totalMaxHp = totalMaxHp + obj:GetMaxHP()
	end 
	if totalMaxHp == 0 then return 0 end 
	return totalHp/totalMaxHp
end 

--找到敌人最密集的区域中心
function clsTeam:FindDensestPoint()
	local enemy_teams = self:GetEnemyList()
	if not enemy_teams then 
		return nil 
	end
	
	local retPoint
	local math_floor = math.floor
	local GRID_W,GRID_H = 256,256
	local grid_info = {}
	
	-- 统计各格子人数
	for _, team in pairs(enemy_teams) do
		local memberList = team:GetMemberList() or {}
		for _, enemy in ipairs(memberList) do
			if not enemy:IsDead() then
				local x,y = enemy:getPosition()
				x = math_floor(x/GRID_W)	--用位移运算应该快些
				y = math_floor(y/GRID_H)
				grid_info[x] = grid_info[x] or {}
				if grid_info[x][y] then grid_info[x][y] = grid_info[x][y] + 1 else grid_info[x][y] = 1 end 
			end
		end
	end
	
	-- 找到最密集格子
	local max_grid = {}
	local max_count = 0
	for i, col_list in pairs(grid_info) do
		for j, count in pairs(col_list) do
			if count > max_count then
				max_count = count
				max_grid.x, max_grid.y = i, j
			end
		end
	end
	
	-- 得到最终坐标点
	if max_count > 0 then
		local dstX = max_grid.x*GRID_W + GRID_W/2
		local dstY = max_grid.y*GRID_H + GRID_H/2
		return { dstX, dstY }
	end
	
	return nil
end
