module("const", package.seeall)

-- 币种
CURRENCY = {
	GOLD = 1,
	DIAMOND = 2,
}

--账号类型
ACCOUNT_TYPE = {
	NORMAL = 1,
	QQ = 2,
	WX = 3,
}

---------------------------------------------------------

--战斗方
COMBAT_MYSIDE = 1
COMBAT_OPSIDE = 2

--战斗类型
COMBAT_TYPE = {
	NONE = 0,
	Instant = 1,
	Round = 2,
	Post = 3,
}

--战斗结束原因
COMBAT_QUIT_REASON = {
	CLICK_QUIT = 1,		--点击退出按钮
	RESULT = 2,			--胜负已分
	TIMEOUT = 3,		--超时
}

COMBAT_STATE_READY = 0
COMBAT_STATE_FIGHT = 1
COMBAT_STATE_OVER = 2
