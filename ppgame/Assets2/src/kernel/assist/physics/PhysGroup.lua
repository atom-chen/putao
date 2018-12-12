-------------------------
-- 群组
-------------------------
module("phys", package.seeall)

clsPhysGroup = class("clsPhysGroup", grp.clsIGroup)

function clsPhysGroup:ctor(id)
	grp.clsIGroup.ctor(self, id)
	self.tMemberList = new_weak_table("k")	--成员列表
end

function clsPhysGroup:dtor()
	self:ClearMemberList()
end

function clsPhysGroup:GetMemberList()
	return self.tMemberList
end

function clsPhysGroup:GetMemberCount()
	return table.size(self.tMemberList)
end

function clsPhysGroup:ClearMemberList()
	for obj, _ in pairs(self.tMemberList) do
		self:OnRemoveMember(obj)	--【NOTE:】 从群组移除时回调
	end
	self.tMemberList = new_weak_table("v")
end

function clsPhysGroup:AddMember(obj)
	if self.tMemberList[obj] then
		logger.warn("已经添加过该成员", obj)
		return
	end
	self.tMemberList[obj] = true
	self:OnAddMember(obj)			--【NOTE:】 成功添加进了群组时回调
end

function clsPhysGroup:RemoveMember(obj)
	if self.tMemberList[obj] then
		self:OnRemoveMember(obj)	--【NOTE:】 从群组移除时回调
		self.tMemberList[obj] = nil
	end
end

function clsPhysGroup:OnAddMember(obj)
	obj:OnAddtoPhysGroup(self)
end

function clsPhysGroup:OnRemoveMember(obj)
	obj:OnRemoveFromPhysGroup(self)
end
