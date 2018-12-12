------------------
-- 主角
------------------
clsHeroSpr = class("clsHeroSpr", clsRoleSpr)

-- 构造函数
function clsHeroSpr:ctor(iUid)
	clsRoleSpr.ctor(self, iUid)
end

--析构函数
function clsHeroSpr:dtor()

end

function clsHeroSpr:GetRoleType() 
	return const.ROLE_TYPE.TP_HERO 
end
