------------------
-- clsMonsterSpr
------------------
clsMonsterSpr = class("clsMonsterSpr", clsRoleSpr)

-- 构造函数
function clsMonsterSpr:ctor(iUid)
	clsRoleSpr.ctor(self, iUid)
end

--析构函数
function clsMonsterSpr:dtor()
	
end

function clsMonsterSpr:GetRoleType() 
	return const.ROLE_TYPE.TP_MONSTER 
end
