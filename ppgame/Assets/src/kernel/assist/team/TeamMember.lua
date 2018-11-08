---------------
--
---------------
clsTeamMember = class("clsTeamMember")

function clsTeamMember:ctor()
	self._mTeam = nil
end

function clsTeamMember:dtor()
	self:RemoveFromTeam()
end

function clsTeamMember:GetMyTeamID()
	return self._mTeam and self._mTeam:GetUid()
end

function clsTeamMember:GetMyTeam()
	return self._mTeam
end

function clsTeamMember:IsInTeam(oTeam)
	assert(oTeam)
	return self._mTeam == oTeam
end

-- 申请入队
function clsTeamMember:AddToTeam(oTeam)
	assert(not self._mTeam, "已经在队伍中: "..self._mTeam:GetUid())
	oTeam:AddMember(self)
end

-- 申请离队
function clsTeamMember:RemoveFromTeam()
	if self._mTeam then
		self._mTeam:RemoveMember(self)
	end
end

-- 成功加入某队时回调
function clsTeamMember:OnAddtoTeam(oTeam)
	self._mTeam = oTeam
end

-- 成功离开某队时回调
function clsTeamMember:OnRemoveFromTeam()
	self._mTeam = nil
end

-----------------------
function clsTeamMember:GetPartnerTeamList()
	return self._mTeam and self._mTeam:GetPartnerList()
end

function clsTeamMember:GetPartnerTeamCount()
	return table.size(self:GetPartnerTeamList())
end

function clsTeamMember:GetTeammateCount()
	local partner_teams = self:GetPartnerTeamList()
	local myTeam = self:GetMyTeam()
	local count = 0
	
	if myTeam then count = count + myTeam:GetMemberCount() - 1 end
	count = math.max(0, count)
	
	if partner_teams then
		for _, team in pairs(partner_teams) do
			count = count + team:GetMemberCount()
		end
	end
	
	return count
end

function clsTeamMember:GetEnemyTeamList()
	return self._mTeam and self._mTeam:GetEnemyList()
end

function clsTeamMember:GetEnemyTeamCount()
	return table.size(self:GetEnemyTeamList())
end

function clsTeamMember:GetEnemyCount()
	local enemy_teams = self:GetEnemyTeamList()
	if not enemy_teams then return 0 end
	
	local count = 0
	for _, team in pairs(enemy_teams) do
		count = count + team:GetMemberCount()
	end
	return count
end

function clsTeamMember:GetEnemyList(aliveType)
	local enemyTeams = self:GetEnemyTeamList()
	if not enemyTeams then return {} end
	local enemyList = {}
	for _, grp in pairs(enemyTeams) do
		local memberList = grp:GetMemberList()
		if memberList then
			for _, obj in ipairs(memberList) do
				if aliveType == 1 then 
					if obj:IsAlive() then 
						table.insert(enemyList, obj)
					end 
				elseif aliveType == 2 then 
					if obj:IsDead() then 
						table.insert(enemyList, obj)
					end 
				else 
					table.insert(enemyList, obj)
				end 
			end
		end
	end
	return enemyList
end

function clsTeamMember:GetTeammateList(aliveType)
	local teammateList = {}
	
	local myTeam = self:GetMyTeam()
	if myTeam then
		local memberList = myTeam:GetMemberList()
		if memberList then
			for _,obj in ipairs(memberList) do
				if obj ~= self then
					if aliveType == 1 then 
						if obj:IsAlive() then 
							table.insert(teammateList, obj)
						end 
					elseif aliveType == 2 then 
						if obj:IsDead() then 
							table.insert(teammateList, obj)
						end 
					else 
						table.insert(teammateList, obj)
					end 
				end
			end
		end
	end
	
	local partner_teams = self:GetPartnerTeamList()
	if partner_teams then
		for _, team in pairs(partner_teams) do
			local huobanList = team:GetMemberList() 
			if huobanList then
				for _, obj in ipairs(huobanList) do
					if aliveType == 1 then 
						if obj:IsAlive() then 
							table.insert(teammateList, obj)
						end 
					elseif aliveType == 2 then 
						if obj:IsDead() then 
							table.insert(teammateList, obj)
						end 
					else 
						table.insert(teammateList, obj)
					end 
				end
			end
		end
	end
	
	return teammateList
end 

function clsTeamMember:IsEnemyWith(fighterObj)
	local enemyTeams = self:GetEnemyTeamList()
	if not enemyTeams then return false end
	for _, grp in pairs(enemyTeams) do
		local memberList = grp:GetMemberList()
		if memberList then
			for _, obj in ipairs(memberList) do
				if fighterObj == obj then 
					return true 
				end 
			end
		end
	end
	return false
end

function clsTeamMember:IsPartenerWith(fighterObj)
	local myTeam = self:GetMyTeam()
	if myTeam then
		local memberList = myTeam:GetMemberList()
		if memberList then
			for _,obj in ipairs(memberList) do
				if fighterObj == obj then
					return true
				end
			end
		end
	end
	
	local partner_teams = self:GetPartnerTeamList()
	if partner_teams then
		for _, team in pairs(partner_teams) do
			local huobanList = team:GetMemberList() 
			if huobanList then
				for _, obj in ipairs(huobanList) do
					if fighterObj == obj then
						return true
					end
				end
			end
		end
	end
	
	return false
end 
