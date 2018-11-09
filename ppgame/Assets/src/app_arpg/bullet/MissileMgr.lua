-----------------
-- 法术球管理器
-----------------
module("missile",package.seeall)

local CFG_MISSILE = {
	["clsMissileStatic"] 	= require("app_arpg.bullet.MissileStatic"),
	["clsMissileLine"] 		= require("app_arpg.bullet.MissileLine"),
	["clsMissileParabola"] 	= require("app_arpg.bullet.MissileParabola"),
	["clsMissileTrack"] 	= require("app_arpg.bullet.MissileTrack"),
	["clsMissilePossessed"] = require("app_arpg.bullet.MissilePossessed"),
	["clsMissileP2P"] 		= require("app_arpg.bullet.MissileP2P"),
}

local _iMissileID = 0


ClsMissileMgr = class("ClsMissileMgr", clsCoreObject)

function ClsMissileMgr:ctor()
	clsCoreObject.ctor(self)
	
	self._tMissileList = {}
	
	g_EventMgr:AddListener(self, "LEAVE_WORLD", function(thisObj)
		self:DestroyAllMissiles()
	end)
end

function ClsMissileMgr:dtor()
	self:DestroyAllMissiles()
end

-- 创建法术体
function ClsMissileMgr:CreateMissile(casterSpr, tMagicInfo)
	if not casterSpr then return end
	_iMissileID = _iMissileID + 1 
--	logger.normal("创建子弹", _iMissileID)
	local cls = CFG_MISSILE[tMagicInfo.sMissleType]
	self._tMissileList[_iMissileID] = cls.new(_iMissileID, tMagicInfo, casterSpr:GetUid(), casterSpr)
	return self._tMissileList[_iMissileID]
end

-- 销毁法术体
function ClsMissileMgr:DestroyMissile(missile_id)
	if self._tMissileList[missile_id] then
--		logger.normal("销毁子弹", missile_id)
		KE_SafeDelete(self._tMissileList[missile_id])
		self._tMissileList[missile_id] = nil
	end
end

-- 销毁所有法术体
function ClsMissileMgr:DestroyAllMissiles()
	for _, missile in pairs(self._tMissileList) do
		KE_SafeDelete(missile)
	end
	self._tMissileList = {}
end
