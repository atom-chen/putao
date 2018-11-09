---------------------
-- 
---------------------
module("const", package.seeall)

-- 角色跳跃常量
JMP_HEIGHT = 180
JMP_SPEED = 20 
FLIGHT_SPEED = 20

-- 状态结束原因
ST_REASON_COMPLETE = true
ST_REASON_BREAK = false

-- 模型动作名
ANINAME = {
	stand 		= "stand",			--站立
	walk 		= "walk",			--走
	run 		= "run",			--跑
	jump 		= "jump",			--跳
	skill_0_1 	= "skill_0_1",		--攻击
	skill_0_2 	= "skill_0_2",		--攻击
	skill_0_3 	= "skill_0_3",		--攻击
	skill_1 	= "skill_1",		--施法
	skill_2 	= "skill_2",		--施法
	skill_3 	= "skill_3",		--施法
	skill_4 	= "skill_4",		--施法
	skill_5 	= "skill_5",		--施法
	skill_6 	= "skill_6",		--施法
	hit 		= "hit",			--受击
	die 		= "die",			--死亡
	def			= "def",			--防御
	win			= "win",			--赢
	abn			= "abn",			--眩晕
	flight_up	= "flight_up",		--
	flight_down	= "flight_down",	--
}

--模型身体组成部分
BODY_PART = {
	["HAIR"] 	= 1,		--头发
	["HEAD"] 	= 2,		--头
	["BODY"] 	= 3,		--躯干
	["JIAN"] 	= 4,		--肩膀
	["L_HAND"] 	= 5,		--左手
	["R_HAND"] 	= 6,		--右手
	["L_LEG"] 	= 7,		--左脚
	["R_LEG"] 	= 8,		--右脚
	["TAIL"] 	= 10,		--尾巴
}

-- 性别分类
SEX_TYPE = {
	["MAIL"]   = 1,		--男
	["FEMAIL"] = 2,		--女
	["EUNUCH"] = 3,		--中性
}

-- 角色类型
ROLE_TYPE = {
	["TP_UNKNOWN"] 		= 0,		--
	["TP_HERO"] 		= 1,		--主角
	["TP_PLAYER"] 		= 2,		--玩家
	["TP_NPC"] 			= 3,		--NPC
	["TP_MONSTER"] 		= 4,		--怪物
}


-- 最大卡牌星级
MIN_CARD_STARLV = 1
MAX_CARD_STARLV = 5

-- 职业分类
CAREER_TYPE_1 = 1
CAREER_TYPE_2 = 2
CAREER_TYPE_3 = 3
CAREER_TYPE_4 = 4

-- 官职
OFFICE_KING = 1
OFFICE_GENERAL = 2
OFFICE_SOLDIER = 3
OFFICE_NULL	= 0

-- 官职命名
OFFICE_TYPE_2_NAME = {
	[OFFICE_KING] 		= "国王",
	[OFFICE_GENERAL] 	= "将领",
	[OFFICE_SOLDIER] 	= "兵卒",
	[OFFICE_NULL]		= "",
}

--兵种分类
FIGHTER_GENERALNPC	= 0		--将帅(NPC)
FIGHTER_ELING		= 1		--恶灵
FIGHTER_BUBING 		= 2		--步兵
FIGHTER_GONGBING 	= 3		--弓兵
FIGHTER_QIBING 		= 4		--骑兵
FIGHTER_SHUIBING 	= 5		--水兵
FIGHTER_ARTILLERY	= 6		--炮兵

-- 兵种命名
FIGHTER_TYPE_2_CNNAME = {
	[FIGHTER_GENERALNPC]	= "将帅",
	[FIGHTER_ELING]			= "恶灵",
	[FIGHTER_BUBING] 		= "步兵",
	[FIGHTER_GONGBING] 		= "弓兵",
	[FIGHTER_QIBING] 		= "骑兵",
	[FIGHTER_SHUIBING] 		= "水兵",
	[FIGHTER_ARTILLERY]		= "炮兵",
}

-- 最大技能索引
MAX_SKILL_INDEX = 5

-- 技能系
-- 金 火 雷 冰 木 土 风
