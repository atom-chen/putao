------------------
-- 其他玩家
------------------
clsPlayerSpr = class("clsPlayerSpr", clsRoleSpr)

-- 构造函数
function clsPlayerSpr:ctor(iUid)
	clsRoleSpr.ctor(self, iUid)
end

--析构函数
function clsPlayerSpr:dtor()
	
end

function clsPlayerSpr:GetRoleType() 
	return const.ROLE_TYPE.TP_PLAYER 
end
