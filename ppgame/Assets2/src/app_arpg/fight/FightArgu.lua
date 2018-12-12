-------------------
-- 战斗参数
-------------------
module("fight", package.seeall)

clsFightArgu = class("clsFightArgu")

function clsFightArgu:ctor(sCombatType)
	self.sCombatType = sCombatType
	self.tFightGoal = {
		goal_time_limit = 60,		--需限时秒
		goal_kill_num = -1,			--需击杀数(-1表示需全部击杀）
		goal_kill_boss = {},		--需击杀BOSS 
	}
	self.tTeamList = {
		[1] = {
			{ Uid=1,TypeId=10001,ShapeId=10001 },
			{ Uid=2,TypeId=10001,ShapeId=10001 },
			{ Uid=3,TypeId=10001,ShapeId=10001 },
		},
		[2] = {
			{ Uid=4,TypeId=10001,ShapeId=10002 },
			{ Uid=5,TypeId=10001,ShapeId=10002 },
			{ Uid=6,TypeId=10001,ShapeId=10002 },
		},
	}
	self.EndCallback = function() end
	self.bVideo = true
	self.bAffectEnable = true
	self.bHasReadyTime = false
	self.bHasLeaveTime = false 
end

function clsFightArgu:Check()
	local Info = self
	assert(Info.tFightGoal==nil or is_table(Info.tFightGoal), "tFightGoal类型错误")
	assert(Info.tTeamList, "参战队伍序列不可为空")
	local allfighters = {}
	for teamid, fighterlist in pairs(Info.tTeamList) do 
		assert(not table.is_empty(fighterlist), "该队伍为空："..teamid)
		for _, RoleInfo in ipairs(fighterlist) do
			assert(not allfighters[RoleInfo.Uid], "重复添加队员: "..RoleInfo.Uid)
			allfighters[RoleInfo.Uid] = true
		end
	end
	assert(is_function(Info.EndCallback) or Info.EndCallback==nil, "EndCallback必须为函数或为空")
	assert(Info.bVideo==nil or is_boolean(Info.bVideo), "bVideo需传入boolean类型")
end