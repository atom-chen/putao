-------------------------
-- tShapeInfo：形状信息
-- tHarmInfo：伤害信息
-------------------------
module("phys", package.seeall)

clsPhysBody = class("clsPhysBody")

function clsPhysBody:ctor()
	self._iPhysGroupID = nil
	
	self.tShapeInfo = phys.CreateRect(0, 0, 100, 40, 100)
	self.tHarmInfo = nil
end

function clsPhysBody:dtor()
	self:RemoveFromPhysWorld()
	self._iPhysGroupID = nil
	self.tHarmInfo = nil
end

-- 身高
function clsPhysBody:GetBodyHeight()
	return self.tShapeInfo.iBodyHeight
end

-- 设置形状
function clsPhysBody:SetShapeInfo(tShapeInfo)
	self.tShapeInfo.sShapeType = tShapeInfo.sShapeType
	self.tShapeInfo.tShapeDesc = table.clone(tShapeInfo.tShapeDesc)
	self.tShapeInfo.iBodyHeight = tShapeInfo.iBodyHeight
end

-- 获取形状
function clsPhysBody:GetShapeInfo()
	self.tShapeInfo.tShapeDesc.x = self:GetPosX()
	self.tShapeInfo.tShapeDesc.y = self:GetPosY()
	return self.tShapeInfo
end

-- 设置伤害信息
function clsPhysBody:SetHarmInfo(tHarmInfo)
	self.tHarmInfo = table.clone(tHarmInfo)
end

-- 获取伤害信息
function clsPhysBody:GetHarmInfo()
	return self.tHarmInfo
end

-- 碰撞回调
function clsPhysBody:OnCollision(body)
	assert(false, "Override Me")
end


-- 所在碰撞群组ID
function clsPhysBody:GetMyPhysGroupID()
	return self._iPhysGroupID
end

-- 投放到检测空间
function clsPhysBody:AddToPhysWorld(grp_id)
	assert(not self._iPhysGroupID, "已经在物理空间中")
	ClsPhysicsWorld.GetInstance():AddBody(self, grp_id)
end

-- 撤出检测空间
function clsPhysBody:RemoveFromPhysWorld()
	ClsPhysicsWorld.GetInstance():RemoveBody(self)
end

-- 投放到检测空间成功时回调
function clsPhysBody:OnAddtoPhysGroup(oPhysGrp)
	self._iPhysGroupID = oPhysGrp:GetUid()
end

-- 撤出检测空间时回调
function clsPhysBody:OnRemoveFromPhysGroup(oPhysGrp)
	self._iPhysGroupID = nil
end
