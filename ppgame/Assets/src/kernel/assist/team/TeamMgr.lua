---------------------
-- 分组管理
---------------------
ClsTeamMgr = class("ClsTeamMgr", grp.clsIGroupMgr)

function ClsTeamMgr:ctor()
	grp.clsIGroupMgr.ctor(self)
end

function ClsTeamMgr:dtor()

end

-- @override
function ClsTeamMgr:DoCleanup()
	for team_id, grp in pairs(self.tAllGroups) do
		KE_SafeDelete(grp)
		g_EventMgr:FireEvent("DEL_TEAM", team_id)
	end
	self.tAllGroups = {}
end

-- @override
function ClsTeamMgr:CreateGroup(team_id)
	assert(team_id > 0)
	self.tAllGroups[team_id] = self.tAllGroups[team_id] or clsTeam.new(team_id)
	g_EventMgr:FireEvent("NEW_TEAM", team_id, self.tAllGroups[team_id])
	return self.tAllGroups[team_id]
end

-- @override
function ClsTeamMgr:RemoveGroup(team_id)
	grp.clsIGroupMgr.RemoveGroup(self, team_id)
	g_EventMgr:FireEvent("DEL_TEAM", team_id)
end

-- @override
function ClsTeamMgr:SetGroupRelation(team_1, team_2, relation)
	grp.clsIGroupMgr.SetGroupRelation(self, team_1, team_2, relation)
	g_EventMgr:FireEvent("TEAM_RELATION_CHG", team_1, team_2, relation)
end

function ClsTeamMgr:DumpDebugInfo()
	logger.warn("---------开始---------")
	for grpID, grp in pairs(self.tAllGroups) do
		logger.warn(string.format("TeamId=%d  MemberCnt=%d  EnemyCnt=%d  PartnerCnt=%d", 
			grpID, table.size(grp:GetMemberList()), 
			table.size(grp:GetEnemyList()), table.size(grp:GetPartnerList())) )
	end
	logger.warn("---------结束---------")
end