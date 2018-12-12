------------------
-- NPC
------------------
clsNpcSpr = class("clsNpcSpr", clsRoleSpr)

-- 构造函数
function clsNpcSpr:ctor(iUid)
	clsRoleSpr.ctor(self, iUid)
end

--析构函数
function clsNpcSpr:dtor()
	
end

function clsNpcSpr:GetRoleType() 
	return const.ROLE_TYPE.TP_NPC 
end
