-------------------------
-- 配置表
-------------------------
module("setting", package.seeall)

T_card_general = setting.ReLoad("app_arpg.configs.xls.T_card_general")
T_card_hero = setting.ReLoad("app_arpg.configs.xls.T_card_hero")
T_card_soldier = setting.ReLoad("app_arpg.configs.xls.T_card_soldier")
T_card_cfg = table.union( {T_card_hero, T_card_general, T_card_soldier} )
T_npc_cfg = setting.ReLoad("app_arpg.configs.xls.T_npc_cfg")
T_stage_cfg = setting.ReLoad("app_arpg.configs.xls.T_stage_cfg")
T_buff = setting.ReLoad("app_arpg.configs.xls.T_buff")
T_buff_mutex = setting.ReLoad("app_arpg.configs.xls.T_buff_mutex")
T_skill_cfg = setting.ReLoad("app_arpg.configs.skill.T_skill_cfg")
T_round_skill_cfg = setting.ReLoad("app_arpg.configs.skill.T_round_skill_cfg")


------------------
--技能
------------------
local ALL_SKILL_PLAY_INFO = {}
function GetSkillPlayInfo(iSkillId)
	ALL_SKILL_PLAY_INFO[iSkillId] = ALL_SKILL_PLAY_INFO[iSkillId] or setting.Get(string.format("app_arpg.configs.skill.T_skill_%d", iSkillId))
	return ALL_SKILL_PLAY_INFO[iSkillId]
end

local SKILL_RANGE_INFO = {}
function GetSkillRange(iSkillId)
	if SKILL_RANGE_INFO[iSkillId] then 
		return SKILL_RANGE_INFO[iSkillId][1]
	end
	
	local minRange
	local maxRange
	local curRange
	local playinfo = GetSkillPlayInfo(iSkillId)
	
	for _, info in pairs(playinfo) do
		if info.cmdName == "v_role_sprint" then
			--50实际上应该为特效的攻击范围半径
			curRange = 50
		elseif info.cmdName == "v_add_missile" then
			local tTrackCfg = info.args.tMagicInfo.tTrackCfg
			local MissileType = info.args.tMagicInfo.sMissleType
			
			if MissileType == "clsMissileStatic" then
				--50实际上应该为特效的攻击范围半径 
				curRange = tTrackCfg.iDis + 50
			elseif MissileType == "clsMissileTrack" then
				--50实际上应该为特效的攻击范围半径
				--3实际上应该为特效的生命周期
				curRange = tTrackCfg.iMoveSpeed * tTrackCfg.iRemainFrame / 2 * 3
			elseif MissileType == "clsMissileLine" then
				--50实际上应该为特效的攻击范围半径
				curRange = tTrackCfg.iMoveDis / 2
			elseif MissileType == "clsMissileParabola" then
				--50实际上应该为特效的攻击范围半径
				curRange = tTrackCfg.iMoveDis / 2 * 3
			elseif MissileType == "clsMissilePossessed" then
				--100实际上应该为特效的攻击范围半径
				curRange = 60
			end
		else 
			--100实际上应该为特效的攻击范围半径
			curRange = 100
		end
		
		minRange = minRange and math.min(curRange, minRange) or curRange
		maxRange = maxRange and math.max(curRange, maxRange) or curRange
	end
	
	SKILL_RANGE_INFO[iSkillId] = { math.ceil((minRange + maxRange)/2), minRange, maxRange }
	
	return SKILL_RANGE_INFO[iSkillId][1]
end
