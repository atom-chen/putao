----------------------
-- 角色属性管理器
----------------------
clsRoleEntity = class("clsRoleEntity",clsCoreObject)

clsRoleEntity:RegSaveVar("Pid", TYPE_CHECKER.INT)					--PID
clsRoleEntity:RegSaveVar("Uid", TYPE_CHECKER.INT)					--UID
clsRoleEntity:RegSaveVar("TypeId", gameutil.IsValidCardTypeId)  	--TypeId
clsRoleEntity:RegSaveVar("RoleType", TYPE_CHECKER.INT)				--角色类型
clsRoleEntity:RegSaveVar("ShapeId", TYPE_CHECKER.INT)				--外观
--
clsRoleEntity:RegSaveVar("UserName", TYPE_CHECKER.STRING_NIL)		--用户名
clsRoleEntity:RegSaveVar("Nick", TYPE_CHECKER.STRING_NIL)			--昵称
clsRoleEntity:RegSaveVar("CurExp", TYPE_CHECKER.INT)				--经验值
clsRoleEntity:RegSaveVar("Grade", TYPE_CHECKER.INT)				--等级
clsRoleEntity:RegSaveVar("VipLevel", TYPE_CHECKER.INT)				--VIP等级
clsRoleEntity:RegSaveVar("Money", TYPE_CHECKER.INT)				--金币
clsRoleEntity:RegSaveVar("Diamond", TYPE_CHECKER.INT)				--钻石
clsRoleEntity:RegSaveVar("EquipInfo", TYPE_CHECKER.TABLE_NIL)		--装备表
--
clsRoleEntity:RegSaveVar("CombatForce", TYPE_CHECKER.INT)			--战斗力
clsRoleEntity:RegSaveVar("Morale", TYPE_CHECKER.INT_NIL)			--士气
clsRoleEntity:RegSaveVar("AngerPower", gameutil.IsValidAngerPower)	--怒气值
--
clsRoleEntity:RegSaveVar("MagicAtk", TYPE_CHECKER.INT)				--法攻
clsRoleEntity:RegSaveVar("MagicDef", TYPE_CHECKER.INT)				--法防
clsRoleEntity:RegSaveVar("CurMP", TYPE_CHECKER.INT)				--当前法量

clsRoleEntity:RegSaveVar("MaxHP", TYPE_CHECKER.INT)				--最大血量
clsRoleEntity:RegSaveVar("CurHP", TYPE_CHECKER.INT)				--当前血量
clsRoleEntity:RegSaveVar("PhyAtk", TYPE_CHECKER.INT)				--攻击
clsRoleEntity:RegSaveVar("PhyDef", TYPE_CHECKER.INT)				--防御
clsRoleEntity:RegSaveVar("CriAtk", TYPE_CHECKER.INT)				--暴击
clsRoleEntity:RegSaveVar("CriDef", TYPE_CHECKER.INT)				--抗暴
clsRoleEntity:RegSaveVar("CriProb", TYPE_CHECKER.INT)				--暴击概率
clsRoleEntity:RegSaveVar("BuffPhyAtk", TYPE_CHECKER.INT)
clsRoleEntity:RegSaveVar("BuffPhyDef", TYPE_CHECKER.INT)
clsRoleEntity:RegSaveVar("BuffCriProb", TYPE_CHECKER.INT)
--
clsRoleEntity:RegSaveVar("RushSpeed", TYPE_CHECKER.INT_NIL)		--冲刺速度
clsRoleEntity:RegSaveVar("RunSpeed", TYPE_CHECKER.INT_NIL)			--奔跑速度
clsRoleEntity:RegSaveVar("WalkSpeed", TYPE_CHECKER.INT_NIL)		--行走速度
-- view prop
clsRoleEntity:RegSaveVar("SceneId", TYPE_CHECKER.INT_NIL)			--所在场景
clsRoleEntity:RegSaveVar("PosX", TYPE_CHECKER.INT)					--位置X
clsRoleEntity:RegSaveVar("PosY", TYPE_CHECKER.INT)					--位置Y
clsRoleEntity:RegSaveVar("PosH", TYPE_CHECKER.INT)					--位置H
clsRoleEntity:RegSaveVar("CurDir", TYPE_CHECKER.INT)				--朝向 [0~2PI]
clsRoleEntity:RegSaveVar("CurMoveSpeed", TYPE_CHECKER.INT)			--水平方向速度
clsRoleEntity:RegSaveVar("CurSkySpeed", TYPE_CHECKER.INT)			--竖直方向速度

function clsRoleEntity:ctor(Uid, TypeId)
	assert(setting.T_card_cfg[TypeId], "无效的TypeId："..TypeId)
	clsCoreObject.ctor(self)
	
	self:Set_Uid(Uid)
	self:Set_TypeId(TypeId)
	self:Set_ShapeId(10001)
	self:Set_RoleType(const.ROLE_TYPE.TP_MONSTER)
	self:Set_RushSpeed(20)
	self:Set_RunSpeed(8)
	self:Set_WalkSpeed(5)
	self:Set_PosX(100)
	self:Set_PosY(100)
	self:Set_PosH(0)
	self:Set_CurDir(0)
	self:Set_CurMoveSpeed( self:Get_RunSpeed() )
	self:Set_CurSkySpeed(0)
	self:Set_MaxHP(15000)
	self:Set_CurHP(15000)
	self:Set_PhyAtk(1000)
	self:Set_PhyDef(100)
	self:Set_MagicAtk(10000)
	self:Set_MagicDef(800)
	self:Set_CriAtk(2)
	self:Set_CriDef(0.1)
	self:Set_CriProb(30)
	self:Set_BuffPhyAtk(0)
	self:Set_BuffPhyDef(0)
	self:Set_BuffCriProb(0)
	self:Set_Nick("战士"..self:Get_Uid())
--	self:InitByCfg()
end

function clsRoleEntity:dtor()
	
end

function clsRoleEntity:InitByCfg()
	local cfg = self:GetCfgInfo()
	for k, v in pairs(cfg) do 
		self:SetAttrSilent(k, table.clone(v))
	end
end

function clsRoleEntity:GetCfgInfo()
	return setting.T_card_cfg[self:Get_TypeId()]
end

function clsRoleEntity:GetHPPercent()
	return self:Get_CurHP()/self:Get_MaxHP()
end

function clsRoleEntity:AddHP(iHp)
	local curHP = math.Limit(self:Get_CurHP()+iHp, 0, self:Get_MaxHP())
	self:Set_CurHP(curHP)
	return curHP
end

function clsRoleEntity:AddMaxHP(iValue)
	local curValue = math.Limit(self:Get_MaxHP()+iValue, 100)
	self:Set_MaxHP(curValue)
	if self:Get_CurHP() > curValue then
		self:Set_CurHP(curValue)
	end
	return curValue
end


function clsRoleEntity:setPosition(x,y)
	self:Set_PosX(x)
	self:Set_PosY(y)
end

function clsRoleEntity:getPosition()
	return self:Get_PosX(), self:Get_PosY()
end

function clsRoleEntity:getPosition3D()
	return self:Get_PosX(), self:Get_PosY(), self:Get_PosH()
end 

function clsRoleEntity:setPosition3D()
	self:Set_PosX()
	self:Set_PosY()
	self:Set_PosH()
end 

function clsRoleEntity:AddCurSkySpeed(iDelta)
	local newSpeed = self:Get_CurSkySpeed() + iDelta
	self:Set_CurSkySpeed( newSpeed )
	return newSpeed
end

function clsRoleEntity:FaceTo(x,y)
	local sx, sy = self:getPosition()
	local dX, dY = x-sx, y-sy
	if dX == 0 and dY == 0 then return end
	self:Set_CurDir( math.Vector2Radian(dX, dY) )
end
