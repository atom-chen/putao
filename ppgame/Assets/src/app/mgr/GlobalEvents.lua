-------------------------
-- 游戏逻辑层的全局事件
-------------------------
g_EventMgr:RegisterEventType("ASK_ESC_GAME")
--状态机
g_EventMgr:RegisterEventType("LOGIN_STATE")				--登录状态变更
--游戏逻辑
g_EventMgr:RegisterEventType("GAME_CUR_WANFA")
g_EventMgr:RegisterEventType("GAME_ADD_BILLPAPER")
g_EventMgr:RegisterEventType("GAME_DEL_BILLPAPER")
g_EventMgr:RegisterEventType("GAME_BILL_SUCC")
g_EventMgr:RegisterEventType("INPUT_YZM")
g_EventMgr:RegisterEventType("screeting")
g_EventMgr:RegisterEventType("thetime")
g_EventMgr:RegisterEventType("LEDNUM")
g_EventMgr:RegisterEventType("cancelbet")
g_EventMgr:RegisterEventType("RechargeOver")
g_EventMgr:RegisterEventType("redbag_cd")
g_EventMgr:RegisterEventType("OVERTIPS")

---- arpg ---------
--战斗事件
g_EventMgr:RegisterEventType("START_COMBAT")			--战斗开始
g_EventMgr:RegisterEventType("END_COMBAT")				--战斗结束
--回合制
g_EventMgr:RegisterEventType("ROUND_BEGIN")				--新回合开始
g_EventMgr:RegisterEventType("ROUND_END")				--一回合结束
--队伍事件
g_EventMgr:RegisterEventType("NEW_TEAM")				--有新队伍成立
g_EventMgr:RegisterEventType("DEL_TEAM")				--有队伍解散
g_EventMgr:RegisterEventType("TEAM_ADD_MEMBER")			--成员入队
g_EventMgr:RegisterEventType("TEAM_DEL_MEMBER")			--成员离队
g_EventMgr:RegisterEventType("TEAM_RELATION_CHG")		--队伍间敌友关系变更
--角色事件
g_EventMgr:RegisterEventType("ROLE_DIE")				--角色死亡
g_EventMgr:RegisterEventType("ROLE_HANDOP")				--手动操作
